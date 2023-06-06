import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as GeoFirestore from 'geofirestore';

admin.initializeApp();

const firestore = admin.firestore();
const geoFirestore = GeoFirestore.initializeApp(firestore);
const hospitalLocationsCollection = geoFirestore.collection("hospitalsLocationsSOS");

exports.cancelPendingRequests = functions.pubsub
  .schedule("every 1 minutes")
  .onRun(async (context: functions.EventContext<Record<string, string>>) => {
    const currentTime = admin.firestore.Timestamp.now();
    const thresholdTime = currentTime.toMillis() - (1 * 60 * 1000);

    const pendingRequestsRef = firestore.collection("pendingRequests");
    const querySnapshot = await pendingRequestsRef
      .where("status", "==", "pending")
      .where("timestamp", "<=", admin.firestore.Timestamp.fromMillis(thresholdTime))
      .get();

    const deletionPromises: Promise<void>[] = [];
    const batch = firestore.batch();

    querySnapshot.forEach((doc: admin.firestore.QueryDocumentSnapshot) => {
      const requestId = doc.id;
      const hospitalId = doc.data().hospitalId;
      const userId = doc.data().userId;

      // Get the necessary fields from the pending request
      const {
        requestLocation,
        hospitalLocation,
        isUser,
        hospitalName,
        patientCondition,
        timestamp,
        backupNumber,
      } = doc.data();

      const canceledRequestRef = firestore
        .collection("canceledRequests")
        .doc(requestId);
      batch.set(canceledRequestRef, {
        requestLocation,
        hospitalLocation,
        hospitalName,
        hospitalId,
        isUser,
        userId,
        patientCondition,
        timestamp,
        backupNumber,
        cancelReason: "timedOut",
      });

      const userCanceledRef = firestore
        .collection("users")
        .doc(userId)
        .collection("canceledRequests")
        .doc(requestId);
      batch.set(userCanceledRef, {});

      const hospitalCanceledRef = firestore
        .collection("hospitals")
        .doc(hospitalId)
        .collection("canceledRequests")
        .doc(requestId);
      batch.set(hospitalCanceledRef, {});

      const docRef = doc.ref;
      const hospitalDocRef = firestore.collection("hospitals").doc(hospitalId);
      const patientDocRef = firestore.collection("users").doc(userId);

      // Delete "diseases" subCollection within the "pendingRequests" document
      const diseasesRef = docRef.collection("diseases");
      deletionPromises.push(deleteCollection(diseasesRef, batch));

      // Add original pendingRequests document deletion to the batch
      batch.delete(docRef);

      // Add hospital's pendingRequests document deletion to the batch
      const hospitalPendingRef = hospitalDocRef.collection("pendingRequests").doc(doc.id);
      batch.delete(hospitalPendingRef);

      // Add user's pendingRequests document deletion to the batch
      const userPendingRef = patientDocRef.collection("pendingRequests").doc(doc.id);
      batch.delete(userPendingRef);

      // Get the document from Firestore
      firestore.collection("fcmTokens").doc(userId).get().then((snapshot: admin.firestore.DocumentSnapshot) => {
        // Check if the document exists
        if (snapshot.exists) {
          const fcmTokenData = snapshot.data();
          if (fcmTokenData) {
            const tokens = [];
            if (fcmTokenData.fcmTokenAndroid) {
              tokens.push(fcmTokenData.fcmTokenAndroid);
            }
            if (fcmTokenData.fcmTokenIos) {
              tokens.push(fcmTokenData.fcmTokenIos);
            }
            if (fcmTokenData.fcmTokenWeb) {
              tokens.push(fcmTokenData.fcmTokenWeb);
            }
            if (tokens.length !== 0 && fcmTokenData.notificationsLang) {
              let notificationTitle = "";
              let notificationBody = "";
              if (fcmTokenData.notificationsLang === "ar") {
                notificationTitle = "تنبيه طلب سيارة إسعاف";
                notificationBody =
                  "تم رفض طلب سيارة الإسعاف الخاص بك " +
                  "من قبل المستشفى أو انقضت مهلته";
              } else {
                notificationTitle = "Ambulance request alert";
                notificationBody =
                  "Your ambulance request was " +
                  "rejected by the hospital or it has timed out";
              }
              const pay = {
                notification: {
                  title: notificationTitle,
                  body: notificationBody,
                  badge: "1",
                },
                data: {
                  body: notificationBody,
                },
              };
              const options = {
                priority: "high",
              };
              admin.messaging().sendToDevice(tokens, pay, options)
                .then(() => {
                  console.info("Successfully sent");
                }).catch(function (error: Error) {
                  console.warn("Error", error);
                });
            }
          }
        }
      });
    });

    await Promise.all(deletionPromises);
    await batch.commit();
  });

/**
 * Deletes all documents within a Firestore collection.
 * @param {admin.firestore.CollectionReference} collectionRef
 * @param {admin.firestore.WriteBatch} batch - batch object for deletion.
 * @return {Promise<void>} - promise that resolves when all deleted.
 */
async function deleteCollection(collectionRef: admin.firestore.CollectionReference, batch: admin.firestore.WriteBatch) {
  try {
    const documents = await collectionRef.listDocuments();

    documents.forEach((document: admin.firestore.DocumentReference) => {
      batch.delete(document);
    });
  } catch (error) {
    console.error("Error deleting subCollection: ", error);
    throw error;
  }
}

exports.processSOSRequests = functions.firestore
  .document("sosRequests/{sosRequestId}")
  .onCreate(async (snapshot: admin.firestore.DocumentSnapshot) => {
    const sosRequest = snapshot.data();
    if(sosRequest && snapshot.id && sosRequest.requestLocation){
      const sosRequestId = snapshot.id;
      const sosLocation = sosRequest.requestLocation;

      const radiusInKm = 15;

      const query = hospitalLocationsCollection.near({
        center: new admin.firestore.GeoPoint(sosLocation.latitude, sosLocation.longitude),
        radius: radiusInKm
      }).limit(1);

      const querySnapshot = await query.get();

      if (!querySnapshot.empty) {
        console.log("found near hospital");
        const hospitalDoc = querySnapshot.docs[0];
        const hospitalId = hospitalDoc.id;
        const hospitalData = hospitalDoc.data();
        const hospitalLocation = hospitalData.g.geopoint;
        const hospitalName = hospitalData.name;

        const batch = firestore.batch();
        const pendingRequestRef = firestore.collection("pendingRequests").doc();
        const userId = sosRequest.userId;
        batch.set(pendingRequestRef, {
          patientCondition: "sosRequest",
          isUser: true,
          status: "pending",
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          userId: userId,
          requestLocation: sosLocation,
          hospitalName: hospitalName,
          hospitalLocation: hospitalLocation,
          hospitalId: hospitalId,
          backupNumber: "unknown",
        });
        const userPendingRequestRef = firestore
          .collection("users")
          .doc(userId)
          .collection("pendingRequests")
          .doc(pendingRequestRef.id);
        batch.set(userPendingRequestRef, {});
        const hospitalPendingRequestRef = firestore
          .collection("hospitals")
          .doc(hospitalId)
          .collection("pendingRequests")
          .doc(pendingRequestRef.id);
        batch.set(hospitalPendingRequestRef, {});
        const sosRequestRef = firestore
          .collection("sosRequests")
          .doc(sosRequestId);
        batch.delete(sosRequestRef);
        await batch.commit();
        console.log("Pending request made.");
      } else {
        console.log("couldn't find hospital");
      }
    }
  });
