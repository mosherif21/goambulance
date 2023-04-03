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

import '../src/features/account/components/models.dart';

class FirebaseDataAccess extends GetxController {
  static FirebaseDataAccess get instance => Get.find();

  late final String? userId;
  late final FirebaseFirestore fireStore;
  late final FirebaseDatabase fireDatabase;
  late final FirebaseStorage fireStorage;
  late final DocumentReference firestoreUserDocRef;
  UserType userType = UserType.user;
  bool userInitialize = false;

  @override
  void onInit() {
    super.onInit();
    userId = AuthenticationRepository.instance.fireUser.value?.uid;
    fireStore = FirebaseFirestore.instance;
    fireDatabase = FirebaseDatabase.instance;
    fireStorage = FirebaseStorage.instance;
    firestoreUserDocRef = fireStore
        .collection('users')
        .doc('patients')
        .collection('userInfo')
        .doc(userId!);
  }

  Future<FunctionStatus> saveUserPersonalInformation(
      {required UserInfoSave userInfo,
      required XFile profilePic,
      required XFile nationalID}) async {
    try {
      await firestoreUserDocRef.set(userInfo.toJson());

      var userStorageReference =
          fireStorage.ref().child('users').child(userId!);

      final profilePicMetadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': profilePic.path},
      );
      final nationalIdMetadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': nationalID.path},
      );

      if (AppInit.isWeb) {
        await userStorageReference
            .child('profilePic')
            .putData(await profilePic.readAsBytes(), profilePicMetadata);
        await userStorageReference
            .child('nationalId')
            .putData(await nationalID.readAsBytes(), nationalIdMetadata);
      } else {
        await userStorageReference
            .child('profilePic')
            .putFile(File(profilePic.path), profilePicMetadata);
        await userStorageReference
            .child('nationalId')
            .putFile(File(nationalID.path), nationalIdMetadata);
      }

      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
      return FunctionStatus.failure;
    }
  }

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

  Future<void> logoutFirebase() async {
    // if (userType == UserType.user) {
    //   await fireDatabase.ref('locations/users/$userId').set(null);
    // } else {
    //   await fireDatabase.ref('locations/drivers/$userId').set(null);
    // }
  }
}
