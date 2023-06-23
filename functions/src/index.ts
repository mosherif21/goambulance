import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as GeoFirestore from 'geofirestore';
import * as https from 'https';

admin.initializeApp();

const firestore = admin.firestore();
const geoFirestore = GeoFirestore.initializeApp(firestore);
const hospitalLocationsCollection = geoFirestore.collection("hospitalsLocations");

exports.cancelTimedOutRequests = functions.pubsub
  .schedule("every 1 minutes")
  .onRun(async (context: functions.EventContext<Record<string, string>>) => {
    const currentTime = admin.firestore.Timestamp.now();
    const thresholdTime = currentTime.toMillis() - (1 * 60 * 1000);

    const pendingRequestsRef = firestore.collection("pendingRequests");
    const querySnapshot = await pendingRequestsRef
      .where("status", "==", "pending")
      .where("timestamp", "<=", admin.firestore.Timestamp.fromMillis(thresholdTime))
      .get();

    querySnapshot.forEach(async (doc: admin.firestore.QueryDocumentSnapshot) => {
      const requestId = doc.id;

      // Get the necessary fields from the pending request
      const {
        hospitalId,
        userId,
        requestLocation,
        hospitalLocation,
        isUser,
        hospitalName,
        patientCondition,
        timestamp,
        backupNumber,
        hospitalGeohash,
      } = doc.data();

      const batch = firestore.batch();

      const docRef = doc.ref;
      const hospitalDocRef = firestore.collection("hospitals").doc(hospitalId);
      const patientDocRef = firestore.collection("users").doc(userId);

      // Delete "diseases" subCollection within the "pendingRequests" document
      const diseasesRef = docRef.collection("diseases");
      const diseasesDocuments = await diseasesRef.listDocuments();

      diseasesDocuments.forEach((document: admin.firestore.DocumentReference) => {
        batch.delete(document);
      });

      // Add original pendingRequests document deletion to the batch
      batch.delete(docRef);

      // Add hospital's pendingRequests document deletion to the batch
      const hospitalPendingRef = hospitalDocRef.collection("pendingRequests").doc(requestId);
      batch.delete(hospitalPendingRef);

      // Add user's pendingRequests document deletion to the batch
      const userPendingRef = patientDocRef.collection("pendingRequests").doc(requestId);
      batch.delete(userPendingRef);
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

      if (patientCondition === "sosRequest") {
        const sosRequestRef = firestore.collection("sosRequests").doc();
        batch.set(sosRequestRef, {
          userId: userId,
          requestLocation: requestLocation,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });

        const blockedHospitalsDocuments = await docRef.collection('blockedHospitals').listDocuments();
        blockedHospitalsDocuments.forEach((document: admin.firestore.DocumentReference) => {
          batch.set(sosRequestRef.collection('blockedHospitals').doc(document.id), {});
          batch.delete(document);
        });
        batch.set(sosRequestRef.collection('blockedHospitals').doc(hospitalGeohash), {});
      }
      try {
        await batch.commit();
        if (patientCondition === "sosRequest") {
          const userIdEncoded = encodeURIComponent(userId);
          const hospitalNameEncoded = encodeURIComponent(hospitalName);
          const notificationTypeEncoded = encodeURIComponent("sosRequestTimedOut");
          const requestOptions = {
            hostname: 'us-central1-ambulancebookingproject.cloudfunctions.net',
            path: `/sendNotification?notificationType=${notificationTypeEncoded}&userId=${userIdEncoded}&hospitalName=${hospitalNameEncoded}`,
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            }
          };
          const req = https.request(requestOptions);
          req.end();
        } else {
          const userIdEncoded = encodeURIComponent(userId);
          const hospitalNameEncoded = encodeURIComponent(hospitalName);
          const notificationTypeEncoded = encodeURIComponent("requestCanceledTimeout");
          const requestOptions = {
            hostname: 'us-central1-ambulancebookingproject.cloudfunctions.net',
            path: `/sendNotification?notificationType=${notificationTypeEncoded}&userId=${userIdEncoded}&hospitalName=${hospitalNameEncoded}`,
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            }
          };

          const req = https.request(requestOptions);
          req.end();
        }
      } catch (error) {
        console.error(`Error sending notification: ${error}`);
      }

    });
  });

exports.processSOSRequests = functions.firestore
  .document("sosRequests/{sosRequestId}")
  .onCreate(async (snapshot: admin.firestore.DocumentSnapshot) => {
    // Set a timer for 50 seconds
    const timerPromise = new Promise((_, reject) => setTimeout(() => reject('timeout'), 50000));
    try {
      const result = await Promise.race([timerPromise, processSOSRequests(snapshot)]);
      // Otherwise, the function executed within the time limit
      console.log('sos request made successfully');
    } catch (err) {
      if (err === 'timeout') {
        // Check if the result is from the timer or the function
        console.log('No hospital found after 50 seconds, creating another sos request');
        const sosRequestId = snapshot.id;
        const sosRequestData = snapshot.data();
        if (sosRequestData && sosRequestData.userId && sosRequestData.requestLocation) {
          const sosRequestRef = firestore
            .collection("sosRequests")
            .doc(sosRequestId);
          const userId = sosRequestData.userId;
          const sosLocation = sosRequestData.requestLocation;
          const blockedHospitalsDocuments = await sosRequestRef.collection('blockedHospitals').listDocuments();
          const batch = firestore.batch();
          batch.delete(sosRequestRef);
          const sosRequestRefNew = firestore
            .collection("sosRequests")
            .doc();
          batch.set(sosRequestRefNew, {
            userId: userId,
            requestLocation: sosLocation,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
          });
          blockedHospitalsDocuments.forEach((document: admin.firestore.DocumentReference) => {
            batch.set(sosRequestRefNew.collection('blockedHospitals').doc(document.id), {});
            batch.delete(document);
          });
          await batch.commit();
          console.log('New sos request created successfully');
        }
        else {
          console.log('Failed to create new sos request, it\'s deleted');
        }
        return;
      } else {
        console.log(`an error occurred ${err}`);
      }
    }
  });

async function processSOSRequests(snapshot: admin.firestore.DocumentSnapshot) {
  const sosRequestData = snapshot.data();
  if (sosRequestData && sosRequestData.userId && sosRequestData.requestLocation) {
    const sosRequestId = snapshot.id;
    const sosRequestRef = firestore
      .collection("sosRequests")
      .doc(sosRequestId);
    const sosLocation = sosRequestData.requestLocation;
    const userId = sosRequestData.userId;
    let radiusInKm = 50;
    let querySnapshot;
    let sosRequestDeleted = false;
    const blockedHospitalsGeoHashes: string[] = [];
    const blockedHospitalsRef = firestore
      .collection("sosRequests")
      .doc(sosRequestId)
      .collection("blockedHospitals");
    const blockedHospitalsDocuments = await blockedHospitalsRef.listDocuments();
    blockedHospitalsDocuments.forEach((document: admin.firestore.DocumentReference) => {
      blockedHospitalsGeoHashes.push(document.id);
    });

    while (!querySnapshot || querySnapshot.empty) {
      if (sosRequestDeleted) {
        console.log("sosRequest document was deleted.");
        return;
      }

      const query = blockedHospitalsGeoHashes.length !== 0 ? hospitalLocationsCollection
        .near({
          center: new admin.firestore.GeoPoint(sosLocation.latitude, sosLocation.longitude),
          radius: radiusInKm
        })
        .where('g.geohash', 'not-in', blockedHospitalsGeoHashes)
        .limit(1) :
        hospitalLocationsCollection.near({
          center: new admin.firestore.GeoPoint(sosLocation.latitude, sosLocation.longitude),
          radius: radiusInKm
        })
          .limit(1);

      querySnapshot = await query.get();

      if (!querySnapshot.empty) {
        console.log(`Hospital found within ${radiusInKm} km radius`);
      }

      const sosRequestSnapshot = await sosRequestRef.get();
      sosRequestDeleted = !sosRequestSnapshot.exists;

      if (sosRequestDeleted) {
        console.log("sosRequest document was deleted");
        return;
      }
    }

    const hospitalDoc = querySnapshot.docs[0];
    const hospitalId = hospitalDoc.id;
    const hospitalData = hospitalDoc.data();
    const hospitalLocation = hospitalData.g.geopoint;
    const hospitalGeohash = hospitalData.g.geohash;
    const hospitalName = hospitalData.name;

    const batch = firestore.batch();
    const pendingRequestRef = firestore.collection("pendingRequests").doc();
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
      hospitalGeohash: hospitalGeohash,
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
    batch.delete(sosRequestRef);
    const pendingBlockedHospitals = pendingRequestRef.collection("blockedHospitals");
    blockedHospitalsGeoHashes.forEach((geohash: string) => {
      const blockedHospitalDoc = pendingBlockedHospitals.doc(geohash);
      batch.set(blockedHospitalDoc, {});
    });
    blockedHospitalsDocuments.forEach((document: admin.firestore.DocumentReference) => {
      batch.delete(document);
    });
    await batch.commit();
    const userIdEncoded = encodeURIComponent(userId);
    const hospitalNameEncoded = encodeURIComponent(hospitalName);
    const notificationTypeEncoded = encodeURIComponent("sosRequestSent");
    const requestOptions = {
      hostname: 'us-central1-ambulancebookingproject.cloudfunctions.net',
      path: `/sendNotification?notificationType=${notificationTypeEncoded}&userId=${userIdEncoded}&hospitalName=${hospitalNameEncoded}`,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      }
    };
    const request = https.request(requestOptions, (response) => {
      console.log(`Notification sent to user ${userId}`);
    });
    request.on('error', (error) => {
      console.log(`Error sending notification to user ${userId}: ${error}`);
    });
    request.end();
  } else {
    console.log("sosRequest document missing required fields");
  }
  return 'completed';
}

exports.sendNotification = functions.https.onRequest(async (request, response) => {
  const notificationType = request.query.notificationType as string;
  let userId = request.query.userId as string;
  console.log(userId);
  console.log(notificationType);
  const hospitalName = notificationType !== "criticalRequestAccepted" && notificationType !== "criticalRequestDenied" ? request.query.hospitalName : null;

  if (!notificationType || !userId) {
    console.error("Missing parameters");
    response.status(400).send("Missing parameters");
    return;
  }

  let notificationsLang = "en";
  let notificationTitle = "";
  let notificationBody = "";
  const fcmTokenRef = firestore.collection("fcmTokens").doc(userId);
  const fcmTokenDoc = await fcmTokenRef.get();
  if (fcmTokenDoc.exists) {
    const fcmTokenData = fcmTokenDoc.data();
    if (fcmTokenData) {
      if (fcmTokenData.notificationsLang) {
        notificationsLang = fcmTokenData.notificationsLang;
      }
    }
  }

  switch (notificationType) {
    case "requestCanceledHospital":
      notificationTitle = notificationsLang === "en" ? "Ambulance request Canceled" : "تم إلغاء طلب الإسعاف";
      notificationBody = notificationsLang === "en" ? `Sorry, ${hospitalName} has canceled your ambulance request` : `عذرًا ، ألغت ${hospitalName} طلب الإسعاف الخاص بك`;
      break;
    case "requestCanceledTimeout":
      notificationTitle = notificationsLang === "en" ? "Ambulance request timed out" : "انقضت مهلة طلب الإسعاف";
      notificationBody = notificationsLang === "en" ? `Your ambulance request for ${hospitalName} has timed out` : `انقضت مهلة طلب سيارة الإسعاف لـ ${hospitalName}`;
      break;
    case "requestAccepted":
      notificationTitle = notificationsLang === "en" ? "Ambulance request Accepted" : "تم قبول طلب الإسعاف";
      notificationBody = notificationsLang === "en" ? `${hospitalName} has accepted your ambulance request` : `قبلت ${hospitalName} طلب سيارة الإسعاف الخاص بك`;
      break;
    case "requestAssigned":
      notificationTitle = notificationsLang === "en" ? "Ambulance request Assigned" : "تم تعيين طلب الاسعاف";
      notificationBody = notificationsLang === "en" ? `${hospitalName} has assigned an ambulance to your request` : `تم تعيين سيارة إسعاف من ${hospitalName} لطلبك`;
      break;
    case "requestOngoing":
      notificationTitle = notificationsLang === "en" ? "Ambulance request ongoing" : "طلب الإسعاف جاري";
      notificationBody = notificationsLang === "en" ? `The ambulance for your request from ${hospitalName} is on its way` : `سيارة الإسعاف لطلبك من ${hospitalName} في طريقها إليك`;
      break;
    case "ambulanceNear":
      notificationTitle = notificationsLang === "en" ? "Ambulance is near" : "سيارة الإسعاف قريبة منك";
      notificationBody = notificationsLang === "en" ? `The ambulance for your request from ${hospitalName} is near` : `سيارة الإسعاف لطلبك من ${hospitalName} قريبة منك`;
      break;
    case "ambulanceArrived":
      notificationTitle = notificationsLang === "en" ? "Ambulance arrived" : "وصلت السيارة إسعاف";
      notificationBody = notificationsLang === "en" ? `The ambulance for your request from ${hospitalName} has arrived at your location` : `وصلت سيارة الإسعاف لطلبك من ${hospitalName} إلى موقعك`;
      break;
    case "requestCompleted":
      notificationTitle = notificationsLang === "en" ? "Ambulance request completed" : "اكتمل طلب الإسعاف";
      notificationBody = notificationsLang === "en" ? `Your ambulance request for ${hospitalName} was completed` : `تم إكمال طلب سيارة الإسعاف الخاصة بك لـ ${hospitalName}`;
      break;
    case "criticalRequestAccepted":
      notificationTitle = notificationsLang === "en" ? "Critical user request accepted" : "تم قبول طلب مستخدم الطوارئ";
      notificationBody = notificationsLang === "en" ? "Your critical user request has been accepted" : "تم قبول طلب المستخدم المهم الخاص بك";
      break;
    case "criticalRequestDenied":
      notificationTitle = notificationsLang === "en" ? "Critical user request denied" : "تم رفض طلب المستخدم المهم";
      notificationBody = notificationsLang === "en" ? "Sorry, your critical user request was denied" : "عذرا ، تم رفض طلب مستخدم الطوارئ الخاص بك";
      break;
    case "sosRequestSent":
      notificationTitle = notificationsLang === "en" ? "SOS request sent" : "تم إرسال طلب الأستغاثة";
      notificationBody = notificationsLang === "en" ? `Your SOS request was sent to ${hospitalName}` : `تم إرسال طلب النجدة الخاص بك إلى ${hospitalName}`;
      break;
    case "sosRequestTimedOut":
      notificationTitle = notificationsLang === "en" ? "SOS request timed out" : "انقضت مهلة طلب الأستغاثة";
      notificationBody = notificationsLang === "en" ? `Your SOS request sent to ${hospitalName} has timed out` : `انقضت مهلة طلب الأستغاثة الذي أرسلته إلى ${hospitalName}`;
      break;
    default:
      console.error("Invalid notification type");
      response.status(400).send("Invalid notification type");
      return;
  }

  const batch = firestore.batch();
  const notificationsRef = firestore.collection("notifications").doc(userId);
  const notificationsDoc = await notificationsRef.get();
  if (notificationsDoc.exists) {
    batch.update(notificationsRef, {
      unseenCount: admin.firestore.FieldValue.increment(1),
    });
  } else {
    batch.set(notificationsRef, {
      unseenCount: 1,
    });
  }
  const messagesRef = notificationsRef.collection("messages").doc();
  batch.set(messagesRef, {
    title: notificationTitle,
    body: notificationBody,
    timestamp: admin.firestore.Timestamp.now(),
  });

  try {
    await batch.commit();
    if (fcmTokenDoc.exists) {
      const fcmTokenData = fcmTokenDoc.data();
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
        if (tokens.length !== 0) {
          const pay = {
            notification: {
              title: notificationTitle,
              body: notificationBody,
              badge: "1",
            }
          };
          const options = {
            priority: "high",
          };
          await admin.messaging().sendToDevice(tokens, pay, options);
        }
      }
    }
    response.status(200).send("Notification sent successfully");
  } catch (error) {
    console.error(error);
    response.status(500).send("Error sending notification");
  }
});
