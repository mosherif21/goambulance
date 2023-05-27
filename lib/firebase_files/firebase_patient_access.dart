import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/features/sos_message/controllers/sos_message_controller.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:image_picker/image_picker.dart';

import '../src/constants/enums.dart';
import '../src/features/account/components/models.dart';
import '../src/features/requests/components/making_request/models.dart';
import '../src/general/general_functions.dart';

class FirebasePatientDataAccess extends GetxController {
  static FirebasePatientDataAccess get instance => Get.find();

  late final String userId;
  late final User user;
  late final FirebaseFirestore fireStore;
  late final FirebaseDatabase fireDatabase;
  late final FirebaseStorage fireStorage;
  late final DocumentReference firestoreUserRef;
  late final Reference userStorageReference;
  late final AuthenticationRepository authRep;

  @override
  void onInit() {
    authRep = AuthenticationRepository.instance;
    user = authRep.fireUser.value!;
    userId = user.uid;
    fireStore = FirebaseFirestore.instance;
    fireDatabase = FirebaseDatabase.instance;
    fireStorage = FirebaseStorage.instance;
    firestoreUserRef = fireStore.collection('users').doc(userId);
    userStorageReference = fireStorage.ref().child('users').child(userId);

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
        for (DiseaseItem diseaseItem in diseasesList) {
          {
            final diseaseRef = fireStoreUserDiseasesRef.doc();
            userDataBatch.set(diseaseRef, diseaseItem.toJson());
          }
        }
      }
      await userDataBatch.commit();
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

  Future<List<ContactItem>> getEmergencyContacts() async {
    final contactsList = <ContactItem>[];
    try {
      await firestoreUserRef.collection('emergencyContacts').get().then(
        (contactsSnapshot) {
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
        },
      );
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
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

  Future<FunctionStatus> deleteDocument({
    required DocumentReference documentRef,
  }) async {
    try {
      await documentRef.delete();
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

  Future<FunctionStatus> saveSosMessage({required String sosMessage}) async {
    try {
      await firestoreUserRef.update({'sosMessage': sosMessage});
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

  Future<FunctionStatus> addNewAddress({
    required AddressItem savedAddressData,
    required List<String> currentAddressDocIds,
  }) async {
    try {
      final userDataBatch = fireStore.batch();
      final fireStoreUserAddressRef = firestoreUserRef.collection('addresses');
      if (savedAddressData != null) {
        final addressRef = fireStoreUserAddressRef.doc();
        userDataBatch.set(addressRef, savedAddressData.toJson());
      }
      await userDataBatch.commit();
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

  Future<void> updateCurrentLanguage() async {
    try {
      await fireStore.collection('fcmTokens').doc(userId).update({
        'notificationsLang': isLangEnglish() ? 'en' : 'ar',
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
  }

  Future<FunctionStatus> updateUserDataInfo({
    required AccountDetailsModel accountDetails,
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
      await firestoreUserRef.update(accountDetails.toJson());
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

  Future<FunctionStatus> updateMedicalHistory({
    required MedicalHistoryModel medicalHistoryData,
    required List<String> currentDiseasesDocIds,
  }) async {
    try {
      final userDataBatch = fireStore.batch();
      userDataBatch.update(firestoreUserRef, medicalHistoryData.toJson());
      final fireStoreUserDiseasesRef = firestoreUserRef.collection('diseases');
      for (String diseaseDocId in currentDiseasesDocIds) {
        userDataBatch.delete(fireStoreUserDiseasesRef.doc(diseaseDocId));
      }
      if (medicalHistoryData.diseasesList.isNotEmpty) {
        for (DiseaseItem diseaseItem in medicalHistoryData.diseasesList) {
          {
            final diseaseRef = fireStoreUserDiseasesRef.doc();
            userDataBatch.set(diseaseRef, diseaseItem.toJson());
          }
        }
      }
      await userDataBatch.commit();
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

  Future<FunctionStatus> requestHospital({
    required RequestModel requestInfo,
  }) async {
    try {
      final requestDataBatch = fireStore.batch();

      requestDataBatch.set(requestInfo.requestRef, requestInfo.toJson());
      final medicalHistory = requestInfo.hospitalRequestInfo.medicalHistory;
      if (medicalHistory != null) {
        requestDataBatch.update(
            requestInfo.requestRef, medicalHistory.toJson());
        if (medicalHistory.diseasesList.isNotEmpty) {
          for (DiseaseItem diseaseItem in medicalHistory.diseasesList) {
            {
              final diseaseRef =
                  requestInfo.requestRef.collection('diseases').doc();
              requestDataBatch.set(diseaseRef, diseaseItem.toJson());
            }
          }
        }
      }
      requestDataBatch.set(
          firestoreUserRef
              .collection('pendingRequests')
              .doc(requestInfo.requestRef.id),
          <String, dynamic>{});
      final hospitalPendingRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('pendingRequests')
          .doc(requestInfo.requestRef.id);
      requestDataBatch.set(hospitalPendingRef, <String, dynamic>{});

      await requestDataBatch.commit();
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

  Future<FunctionStatus> cancelHospitalRequest({
    required RequestModel requestInfo,
  }) async {
    try {
      final cancelRequestBatch = fireStore.batch();
      cancelRequestBatch.delete(requestInfo.requestRef);
      final medicalHistory = requestInfo.hospitalRequestInfo.medicalHistory;
      if (medicalHistory != null) {
        if (medicalHistory.diseasesList.isNotEmpty) {
          final diseasesRef = fireStore
              .collection('pendingRequests')
              .doc(requestInfo.requestRef.id)
              .collection('diseases');
          await diseasesRef.get().then((diseasesSnapshot) {
            for (var diseaseDoc in diseasesSnapshot.docs) {
              final diseaseDocId = diseaseDoc.id;
              cancelRequestBatch.delete(diseasesRef.doc(diseaseDocId));
            }
          });
        }
      }
      cancelRequestBatch.delete(firestoreUserRef
          .collection('pendingRequests')
          .doc(requestInfo.requestRef.id));

      final hospitalPendingRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('pendingRequests')
          .doc(requestInfo.requestRef.id);

      cancelRequestBatch.delete(hospitalPendingRef);

      final canceledRequestRef = fireStore
          .collection('canceledRequests')
          .doc(requestInfo.requestRef.id);

      final cancelRequestInfo = CanceledRequestModel(
        requestRef: requestInfo.requestRef,
        userId: userId,
        hospitalId: requestInfo.hospitalId,
        hospitalRequestInfo: requestInfo.hospitalRequestInfo,
        timestamp: requestInfo.timestamp,
        requestLocation: requestInfo.requestLocation,
        hospitalLocation: requestInfo.hospitalLocation,
        cancelReason: 'userCanceled',
        hospitalName: requestInfo.hospitalName,
      );
      cancelRequestBatch.set(canceledRequestRef, cancelRequestInfo.toJson());
      cancelRequestBatch.set(
          firestoreUserRef
              .collection('canceledRequests')
              .doc(requestInfo.requestRef.id),
          <String, dynamic>{});
      final hospitalCanceledRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('canceledRequests')
          .doc(requestInfo.requestRef.id);
      cancelRequestBatch.set(hospitalCanceledRef, <String, dynamic>{});

      await cancelRequestBatch.commit();
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

  Future<void> deleteFcmToken() async {
    try {
      await fireStore.collection('fcmTokens').doc(userId).update({
        'fcmToken${AppInit.isAndroid ? 'Android' : AppInit.isIos ? 'Ios' : 'Web'}':
            FieldValue.delete()
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
  }

  Future<void> logoutFirebase() async {
    await deleteFcmToken();
  }
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
