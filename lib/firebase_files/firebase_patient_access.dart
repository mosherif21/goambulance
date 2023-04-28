import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/sos_message/controllers/sos_message_controller.dart';
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
    required List<DiseaseItem> diseasesList,
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
      if (diseasesList.isNotEmpty) {
        final fireStoreUserDiseasesRef =
            firestoreUserRef.collection('diseases');
        for (var diseaseItem in diseasesList) {
          {
            var diseaseRef = fireStoreUserDiseasesRef.doc();
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
    } catch (err) {
      if (kDebugMode) print(err.toString());
      return FunctionStatus.failure;
    }
  }

  Future<List<ContactItem>> getEmergencyContacts() async {
    final contactsList = <ContactItem>[];
    try {
      await firestoreUserRef
          .collection('emergencyContacts')
          .get()
          .then((contactsSnapshot) {
        for (var contact in contactsSnapshot.docs) {
          final contactDoc = contact.data();
          contactsList.add(
            ContactItem(
              contactName: contactDoc['contactName'].toString(),
              contactNumber: contactDoc['contactNumber'].toString(),
              contactDocumentId: contact.id,
            ),
          );
        }
      });
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
    return contactsList;
  }

  Future<ContactItem?> addEmergencyContact({
    required String contactName,
    required String contactNumber,
  }) async {
    try {
      final docRef =
          await firestoreUserRef.collection('emergencyContacts').add({
        'contactName': contactName,
        'contactNumber': contactNumber,
      });
      return ContactItem(
        contactName: contactName,
        contactNumber: contactNumber,
        contactDocumentId: docRef.id,
      );
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
    return null;
  }

  Future<FunctionStatus> deleteDocument({
    required DocumentReference documentRef,
  }) async {
    try {
      await documentRef.delete();
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
      return FunctionStatus.failure;
    } catch (err) {
      if (kDebugMode) print(err.toString());
      return FunctionStatus.failure;
    }
  }

  Future<FunctionStatus> saveSosMessage({required String sosMessage}) async {
    try {
      await firestoreUserRef.update({'sosMessage': sosMessage});
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
      return FunctionStatus.failure;
    } catch (err) {
      if (kDebugMode) print(err.toString());
      return FunctionStatus.failure;
    }
  }

  Future<void> logoutFirebase() async {}
}
//StreamSubscription? driverLocationStreamSubscription;
// bool listenForDriverLocation = false;
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
