import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

exports.deletePendingRequests = functions.pubsub
    .schedule("every 1 minutes")
    .onRun(async (context) => {
      const currentTime = admin.firestore.Timestamp.now();
      const thresholdTime = currentTime.toMillis() -
        (3 * 60 * 1000); // 3 minutes in milliseconds

      const pendingRequestsRef = admin.firestore()
          .collection("pendingRequests");
      const querySnapshot = await pendingRequestsRef
          .where("status", "==", "pending")
          .where("timestamp", "<=", admin.firestore
              .Timestamp.fromMillis(thresholdTime))
          .get();

      const deletionPromises = [];
      const batch = admin.firestore().batch();

      querySnapshot.forEach((doc) => {
        const hospitalId = doc.data().hospitalId;
        const patientId = doc.data().patientId;
        const docRef = doc.ref;
        const hospitalDocRef = admin.firestore().collection("hospitals")
            .doc(hospitalId);
        const patientDocRef = admin.firestore()
            .collection("users").doc(patientId);

        // Add original pendingRequests document deletion to the batch
        batch.delete(docRef);

        // Add hospital's pendingRequests document deletion to the batch
        const hospitalPendingRef = hospitalDocRef
            .collection("pendingRequests").doc(doc.id);
        batch.delete(hospitalPendingRef);

        // Add user's pendingRequests document deletion to the batch
        const userPendingRef = patientDocRef
            .collection("pendingRequests").doc(doc.id);
        batch.delete(userPendingRef);
      });

      deletionPromises.push(batch.commit());
      return Promise.all(deletionPromises);
    });
