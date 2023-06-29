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

    const promises = querySnapshot.docs.map(async (doc: admin.firestore.QueryDocumentSnapshot) => {
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
        additionalInformation,
        phoneNumber,
        patientAge,
      } = doc.data();

      const batch = firestore.batch();

      const docRef = doc.ref;
      if (!isUser) {
        // Delete "diseases" subCollection within the "pendingRequests" document
        const diseasesDocuments = await docRef.collection("diseases").listDocuments();
        diseasesDocuments.forEach((document: admin.firestore.DocumentReference) => {
          batch.delete(document);
        });
      }
      // Add original pendingRequests document deletion to the batch
      batch.delete(docRef);

      // Add hospital's pendingRequests document deletion to the batch
      const hospitalPendingRef = firestore.collection("hospitals").doc(hospitalId).collection("pendingRequests").doc(requestId);
      batch.delete(hospitalPendingRef);

      // Add user's pendingRequests document deletion to the batch
      const userPendingRef = firestore.collection("users").doc(userId).collection("pendingRequests").doc(requestId);
      batch.delete(userPendingRef);

      if (patientCondition === "sosRequest") {
        const sosRequestRef = firestore.collection("sosRequests").doc(requestId);
        batch.set(sosRequestRef, {
          userId: userId,
          requestLocation: requestLocation,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          phoneNumber: phoneNumber,
          patientAge: patientAge,
        });
        const blockedHospitalsDocuments = await docRef.collection('blockedHospitals').listDocuments();
        blockedHospitalsDocuments.forEach((document: admin.firestore.DocumentReference) => {
          batch.set(sosRequestRef.collection('blockedHospitals').doc(document.id), {});
          batch.delete(document);
        });
        batch.set(sosRequestRef.collection('blockedHospitals').doc(hospitalGeohash), {});
      } else {
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
          phoneNumber,
          backupNumber,
          cancelReason: "timedOut",
          additionalInformation,
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

    await Promise.all(promises);
  });

exports.processSOSRequests = functions.firestore
  .document("sosRequests/{sosRequestId}")
  .onCreate(async (snapshot: admin.firestore.DocumentSnapshot) => {
    // Set a timer for 50 seconds
    const timerPromise = new Promise((_, reject) => setTimeout(() => reject('timeout'), 50000));
    try {
      await Promise.race([timerPromise, processSOSRequests(snapshot)]);
      console.log('sos request made successfully');
    } catch (err) {
      if (err === 'timeout') {
        console.log('No hospital found after 50 seconds, creating another sos request');
        const sosRequestId = snapshot.id;
        const sosRequestData = snapshot.data();
        if (sosRequestData && sosRequestData.userId && sosRequestData.requestLocation && sosRequestData.timestamp && sosRequestData.patientAge) {
          const userId = sosRequestData.userId;
          const sosLocation = sosRequestData.requestLocation;
          const sosRequestTimestamp = sosRequestData.timestamp;
          const sosRequestPatientAge = sosRequestData.patientAge;
          const sosRequestPhoneNumber = sosRequestData.phoneNumber;
          // remember to make it 30 minutes again not 5
          const thirtyMinutesInMs = 5 * 60 * 1000;
          const now = admin.firestore.Timestamp.now();
          const sosRequestRef = firestore
            .collection("sosRequests")
            .doc(sosRequestId);
          const blockedHospitalsDocuments = await sosRequestRef.collection('blockedHospitals').listDocuments();
          let batch = firestore.batch();
          batch.delete(sosRequestRef);
          blockedHospitalsDocuments.forEach((document: admin.firestore.DocumentReference) => {
            batch.delete(document);
          });

          if ((now.toMillis() - sosRequestTimestamp.toMillis()) >= thirtyMinutesInMs) {
            console.log('30 minutes have passed and no hospital found canceling the sos');
            const canceledSosRequestRef = firestore
              .collection("canceledSosRequests")
              .doc(sosRequestId);
            batch.set(canceledSosRequestRef, {
              userId: userId,
            });
            await batch.commit();
            console.log('sos request that exceeded 30 minutes canceled successfully');
          } else {
            await batch.commit();
            batch = firestore.batch();
            const sosRequestRefNew = firestore
              .collection("sosRequests")
              .doc(sosRequestId);
            batch.set(sosRequestRefNew, {
              userId: userId,
              requestLocation: sosLocation,
              timestamp: sosRequestTimestamp,
              patientAge: sosRequestPatientAge,
              phoneNumber: sosRequestPhoneNumber,
            });
            blockedHospitalsDocuments.forEach((document: admin.firestore.DocumentReference) => {
              batch.set(sosRequestRefNew.collection('blockedHospitals').doc(document.id), {});
            });
            await batch.commit();
            console.log('New sos request created successfully');
          }
        }
        else {
          console.log('Failed to process sos request after timeout, it\'s deleted');
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
    const patientAge = sosRequestData.patientAge;
    const phoneNumber = sosRequestData.phoneNumber;
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
    const pendingRequestRef = firestore.collection("pendingRequests").doc(sosRequestId);
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
      additionalInformation: "No additional Information",
      patientAge: patientAge,
      phoneNumber: phoneNumber,
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

interface FcmTokenData {
  fcmTokenAndroid?: string;
  fcmTokenIos?: string;
  fcmTokenWeb?: string;
  notificationsLang?: string;
}

interface RequestParams {
  notificationType?: string;
  userId?: string;
  hospitalName?: string;
}

exports.sendNotification = functions.https.onRequest(async (request, response) => {
  const { notificationType, userId, hospitalName } = request.query as RequestParams;
  if (!notificationType || !userId) {
    console.error("Missing parameters");
    response.status(400).send("Missing parameters");
    return;
  }
  if (notificationType !== "criticalRequestAccepted" && notificationType !== "criticalRequestDenied" && !hospitalName) {
    console.error("Missing parameters");
    response.status(400).send("Missing parameters");
    return;
  }
  let notificationsLang = "en";
  let notificationTitle: string;
  let notificationBody: string;
  const fcmTokenRef = firestore.collection("fcmTokens").doc(userId);
  const fcmTokenDoc = await fcmTokenRef.get();
  if (fcmTokenDoc.exists) {
    const fcmTokenData = fcmTokenDoc.data() as FcmTokenData;
    if (fcmTokenData && fcmTokenData.notificationsLang) {
      notificationsLang = fcmTokenData.notificationsLang;
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
      notificationBody = notificationsLang === "en" ? `Your SOS request was sent to ${hospitalName}` : `تم إرسال طلب الأستغاثة الخاص بك إلى ${hospitalName}`;
      break;
    case "sosRequestTimedOut":
      notificationTitle = notificationsLang === "en" ? "SOS request timed out" : "انقضت مهلة طلب الأستغاثة";
      notificationBody = notificationsLang === "en" ? `Your SOS request sent to ${hospitalName} has timed out` : `انقضت مهلة طلب الأستغاثة الذي أرسلته إلى ${hospitalName}`;
      break;
    case "ambulanceEmployeeAssigned":
      notificationTitle = notificationsLang === "en" ? "Ambulance request assigned" : "تم تعيينك لطلب اسعاف";
      notificationBody = notificationsLang === "en" ? "You have been assigned to an ambulance request" : "لقد تم تكليفك بطلب سيارة إسعاف";
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
  await batch.commit();

  if (!fcmTokenDoc.exists) {
    console.log("FCM token doc not found");
    response.status(200).send("FCM token doc not found but notification saved");
    return;
  }
  const fcmTokenData = fcmTokenDoc.data() as FcmTokenData;

  const message: admin.messaging.MessagingPayload = {
    notification: {
      title: notificationTitle,
      body: notificationBody,
      android_channel_id: 'goambulance_channel',
    },
  };

  const options = {
    priority: "high",
  };
  const tokens: string[] = [];
  if (fcmTokenData.fcmTokenAndroid) {
    tokens.push(fcmTokenData.fcmTokenAndroid);
  }
  if (fcmTokenData.fcmTokenIos) {
    tokens.push(fcmTokenData.fcmTokenIos);
  }
  if (tokens.length === 0) {
    console.log("No tokens to send notification to");
    response.status(200).send("No tokens to send notification to but notification saved");
    return;
  }

  const messaging = admin.messaging();
  const sendNotifications = tokens.map((token) => messaging.sendToDevice(token, message, options));
  await Promise.all(sendNotifications);

  response.status(200).send("Notifications sent and saved successfully");
});
