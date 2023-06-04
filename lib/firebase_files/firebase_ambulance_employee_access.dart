import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../authentication/authentication_repository.dart';

class FirebaseAmbulanceEmployeeDataAccess extends GetxController {
  static FirebaseAmbulanceEmployeeDataAccess get instance => Get.find();
  late final String? userId;
  late final FirebaseFirestore fireStore;

  late final FirebaseStorage fireStorage;
  late final DocumentReference firestoreUserRef;
  late final Reference userStorageReference;
  @override
  void onInit() {
    userId = AuthenticationRepository.instance.fireUser.value?.uid;
    fireStore = FirebaseFirestore.instance;
    fireStorage = FirebaseStorage.instance;

    firestoreUserRef = fireStore.collection('users').doc(userId!);
    userStorageReference = fireStorage.ref().child('users').child(userId!);
    super.onInit();
  }
}
