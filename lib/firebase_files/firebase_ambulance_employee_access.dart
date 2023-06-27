import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../authentication/authentication_repository.dart';
import '../src/constants/enums.dart';
import '../src/general/app_init.dart';

class FirebaseAmbulanceEmployeeDataAccess extends GetxController {
  static FirebaseAmbulanceEmployeeDataAccess get instance => Get.find();
  late final String userId;
  late final FirebaseFirestore fireStore;

  late final FirebaseStorage fireStorage;
  late final DocumentReference firestoreUserRef;
  late final Reference userStorageReference;
  late final AuthenticationRepository authRep;
  @override
  void onInit() {
    userId = AuthenticationRepository.instance.fireUser.value!.uid;
    fireStore = FirebaseFirestore.instance;
    fireStorage = FirebaseStorage.instance;
    firestoreUserRef = fireStore.collection('users').doc(userId);
    userStorageReference = fireStorage.ref().child('users').child(userId);
    authRep = AuthenticationRepository.instance;
    super.onInit();
  }

  Future<FunctionStatus> saveUserInformation({
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
      final phoneNumber = authRep.fireUser.value!.phoneNumber;
      if (phoneNumber != null) {
        await firestoreUserRef.update({'phoneNumber': phoneNumber});
      }
      authRep.isUserRegistered = true;
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
      return FunctionStatus.failure;
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
      return FunctionStatus.failure;
    }
  }

  Future<HospitalModel?> getHospitalInfo() async {
    try {
      await fireStore
          .collection('hospitals')
          .doc(authRep.employeeUserInfo.hospitalId)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          final snapshotData = snapshot.data();
          if (snapshotData != null) {
            final geoPointLocation =
                snapshotData['location'].toString() as GeoPoint;
            final hospitalInfo = HospitalModel(
              hospitalId: snapshotData['hospitalId'].toString(),
              name: snapshotData['name'].toString(),
              avgAmbulancePrice: snapshotData['avgAmbulancePrice'].toString(),
              geohash: snapshotData['geohash'].toString(),
              location:
                  LatLng(geoPointLocation.latitude, geoPointLocation.longitude),
              hospitalNumber: snapshotData['hospitalNumber'].toString(),
              address: snapshotData['address'].toString(),
            );
            return hospitalInfo;
          }
        }
      });
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
    }
    return null;
  }

  Future<FunctionStatus> updateUserInfo({
    XFile? profilePic,
    XFile? nationalID,
  }) async {
    try {
      final storageProfileRef =
          fireStorage.ref().child('users/$userId/profilePic');

      if (AppInit.isWeb) {
        if (profilePic != null) {
          await userStorageReference
              .child('profilePic')
              .putData(await profilePic.readAsBytes());
          authRep.drawerProfileImageUrl.value =
              await storageProfileRef.getDownloadURL();
        }
        if (nationalID != null) {
          await userStorageReference
              .child('nationalId')
              .putData(await nationalID.readAsBytes());
        }
      } else {
        if (profilePic != null) {
          await userStorageReference
              .child('profilePic')
              .putFile(File(profilePic.path));
          authRep.drawerProfileImageUrl.value =
              await storageProfileRef.getDownloadURL();
        }
        if (nationalID != null) {
          await userStorageReference
              .child('nationalId')
              .putFile(File(nationalID.path));
        }
      }
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
      return FunctionStatus.failure;
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
      return FunctionStatus.failure;
    }
  }
}
