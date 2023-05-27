import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

exports.deletePendingRequests = functions.pubsub
    .schedule("every 1 minutes")
    .onRun(async (context) => {
      const currentTime = admin.firestore.Timestamp.now();
      const thresholdTime = currentTime.toMillis() -
        (1 * 60 * 1000);

      const pendingRequestsRef = admin.firestore()
          .collection("pendingRequests");
      const querySnapshot = await pendingRequestsRef
          .where("status", "==", "pending")
          .where(
              "timestamp",
              "<=",
              admin.firestore.Timestamp.fromMillis(thresholdTime)
          )
          .get();

      const deletionPromises: Promise<void>[] = [];
      const batch = admin.firestore().batch();

      querySnapshot.forEach((doc) => {
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

        const canceledRequestRef = admin.firestore()
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

        const userCanceledRef = admin.firestore()
            .collection("users")
            .doc(userId)
            .collection("canceledRequests")
            .doc(requestId);
        batch.set(userCanceledRef, {});

        const hospitalCanceledRef = admin.firestore()
            .collection("hospitals")
            .doc(hospitalId)
            .collection("canceledRequests")
            .doc(requestId);
        batch.set(hospitalCanceledRef, {});

        const docRef = doc.ref;
        const hospitalDocRef = admin.firestore()
            .collection("hospitals").doc(hospitalId);
        const patientDocRef = admin.firestore()
            .collection("users").doc(userId);

        // Delete "diseases" subCollection within the "pendingRequests" document
        const diseasesRef = docRef.collection("diseases");
        deletionPromises.push(deleteCollection(diseasesRef, batch));

        // Add original pendingRequests document deletion to the batch
        batch.delete(docRef);

        // Add hospital's pendingRequests document deletion to the batch
        const hospitalPendingRef = hospitalDocRef
            .collection("pendingRequests")
            .doc(doc.id);
        batch.delete(hospitalPendingRef);

        // Add user's pendingRequests document deletion to the batch
        const userPendingRef = patientDocRef
            .collection("pendingRequests")
            .doc(doc.id);
        batch.delete(userPendingRef);

        // Get the document from Firestore
        admin.firestore()
            .collection("fcmTokens").doc(userId).get().then((snapshot) => {
              // Check if the document exists
              if (snapshot.exists) {
                const fcmTokenData = snapshot.data();
                if (fcmTokenData) {
                  const tokens: Array<string> = [];
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
                    let notificationTitle ="";
                    let notificationBody ="";
                    if (fcmTokenData.notificationsLang === "ar") {
                      notificationTitle ="تنبيه طلب سيارة إسعاف";
                      notificationBody =
                            "تم رفض طلب سيارة الإسعاف الخاص بك " +
                            "من قبل المستشفى أو انقضت مهلته";
                    } else {
                      notificationTitle =
                            "Ambulance request alert";
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
                    admin.messaging()
                        .sendToDevice(tokens, pay, options)
                        .then((response)=> {
                          console
                              .info("Successfully sent");
                        }).catch(function(error) {
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
 *
 * @param {FirebaseFirestore.CollectionReference} collectionRef
 * @param {FirebaseFirestore.WriteBatch} batch - batch object for deletion.
 * @return {Promise<void>} - promise that resolves when all deleted.
 */
async function deleteCollection(
    collectionRef: FirebaseFirestore.CollectionReference,
    batch: FirebaseFirestore.WriteBatch
) {
  try {
    const documents = await collectionRef.listDocuments();

    documents.forEach((document) => {
      batch.delete(document);
    });
  } catch (error) {
    console.error("Error deleting subCollection: ", error);
    throw error;
  }
}
