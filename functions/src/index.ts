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
        const hospitalId = doc.data().hospitalId;
        const patientId = doc.data().patientId;
        const docRef = doc.ref;
        const hospitalDocRef = admin.firestore()
            .collection("hospitals").doc(hospitalId);
        const patientDocRef = admin.firestore()
            .collection("users").doc(patientId);

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
