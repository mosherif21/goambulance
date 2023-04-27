import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:image_picker/image_picker.dart';

import '../src/constants/enums.dart';
import '../src/features/account/components/models.dart';

class FirebasePatientDataAccess extends GetxController {
  static FirebasePatientDataAccess get instance => Get.find();

  late final String? userId;
  late final FirebaseFirestore fireStore;
  late final FirebaseDatabase fireDatabase;
  late final FirebaseStorage fireStorage;
  late final DocumentReference firestoreUserRef;
  late final Reference userStorageReference;
  @override
  void onInit() {
    userId = AuthenticationRepository.instance.fireUser.value?.uid;
    fireStore = FirebaseFirestore.instance;
    fireDatabase = FirebaseDatabase.instance;
    fireStorage = FirebaseStorage.instance;
    firestoreUserRef = fireStore.collection('users').doc(userId!);
    userStorageReference = fireStorage.ref().child('users').child(userId!);
    super.onInit();
  }

  Future<FunctionStatus> saveUserPersonalInformation({
    required UserInformation userRegisterInfo,
    required XFile profilePic,
    required XFile nationalID,
  }) async {
    try {
      if (AppInit.isWeb) {
        await userStorageReference
            .child('profilePic')
            .putData(await profilePic.readAsBytes());
        await userStorageReference
            .child('nationalId')
            .putData(await nationalID.readAsBytes());
      } else {
        await userStorageReference
            .child('profilePic')
            .putFile(File(profilePic.path));
        await userStorageReference
            .child('nationalId')
            .putFile(File(nationalID.path));
      }
      final userDataBatch = fireStore.batch();
      userDataBatch.set(
        firestoreUserRef,
        userRegisterInfo.toJson(),
      );
      if (userRegisterInfo.diseasesList.isNotEmpty) {
        final fireStoreUserDiseasesRef =
            firestoreUserRef.collection('diseases');
        for (var diseaseItem in userRegisterInfo.diseasesList) {
          {
            var diseaseRef = fireStoreUserDiseasesRef.doc(
                '${userRegisterInfo.diseasesList.indexOf(diseaseItem) + 1}');
            userDataBatch.set(diseaseRef, diseaseItem.toJson());
          }
        }
      }
      await userDataBatch.commit();
      AuthenticationRepository.instance.isUserRegistered = true;
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
      return FunctionStatus.failure;
    }
  }

  Future<void> logoutFirebase() async {}

  // await fireDatabase.ref('users/drivers/$userId').get().then((snapshot) {
  //   if (snapshot.exists) {
  //     userType = UserType.driver;
  //   } else {
  //     userType = UserType.user;
  //   }
  //   if (kDebugMode) print('user type is $userType');
  // });

  //StreamSubscription? driverLocationStreamSubscription;
  // bool listenForDriverLocation = false;
  // Future<void> updateUserLocation(Position position) async {
  //   final userTypeRef = userType == UserType.driver ? 'drivers' : 'users';
  //   final locationRef = 'locations/$userTypeRef/$userId';
  //   await fireDatabase.ref('$locationRef/latitude').set(position.latitude);
  //   await fireDatabase.ref('$locationRef/longitude').set(position.longitude);
  // }
  //
  // void driverLocationChanged() {
  //   driverLocationStreamSubscription = fireDatabase
  //       .ref('locations/drivers/f3MLM25HIGddzihhuAJUYMICQoS2')
  //       .onValue
  //       .listen((event) {
  //     if (event.snapshot.exists) {
  //       if (listenForDriverLocation) {
  //         final snapshot = event.snapshot;
  //         Map<dynamic, dynamic> locationDataMap =
  //             snapshot.value as Map<dynamic, dynamic>;
  //         final latitude =
  //             double.tryParse(locationDataMap['latitude'].toString());
  //         final longitude =
  //             double.tryParse(locationDataMap['longitude'].toString());
  //         if (latitude != null && longitude != null) {
  //           MapsController.instance.getRoute(LatLng(latitude, longitude));
  //         }
  //       }
  //     }
  //   });
  // }
}
