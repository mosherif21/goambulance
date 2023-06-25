import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/features/requests/components/requests_history/models.dart';
import 'package:goambulance/src/features/sos_message/controllers/sos_message_controller.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  late final FirebaseStorage fireStorage;
  late final DocumentReference firestoreUserRef;
  late final DocumentReference firestoreMedicalRef;
  late final CollectionReference fireStoreUserDiseasesRef;
  late final Reference userStorageReference;
  late final AuthenticationRepository authRep;

  @override
  void onInit() {
    authRep = AuthenticationRepository.instance;
    user = authRep.fireUser.value!;
    userId = user.uid;
    fireStore = FirebaseFirestore.instance;
    fireStorage = FirebaseStorage.instance;
    firestoreUserRef = fireStore.collection('users').doc(userId);
    firestoreMedicalRef = fireStore.collection('medicalHistory').doc(userId);
    fireStoreUserDiseasesRef = firestoreMedicalRef.collection('diseases');
    userStorageReference = fireStorage.ref().child('users').child(userId);
    super.onInit();
  }

  Future<FunctionStatus> saveUserPersonalInformation({
    required UserInformation userRegisterInfo,
    required MedicalHistoryModel medicalHistoryModel,
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
      userDataBatch.set(
        firestoreMedicalRef,
        medicalHistoryModel.toJson(),
      );
      if (medicalHistoryModel.diseasesList.isNotEmpty) {
        for (DiseaseItem diseaseItem in medicalHistoryModel.diseasesList) {
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

  Future<List<AddressItem>> getSavedAddresses() async {
    final addressesList = <AddressItem>[];
    try {
      await firestoreUserRef.collection('addresses').get().then(
        (addressesSnapshot) {
          for (var address in addressesSnapshot.docs) {
            final addressDoc = address.data();
            addressesList.add(
              AddressItem(
                  locationName: addressDoc['locationName'].toString(),
                  streetName: addressDoc['streetName'].toString(),
                  apartmentNumber: addressDoc['apartmentNumber'].toString(),
                  floorNumber: addressDoc['floorNumber'].toString(),
                  areaName: addressDoc['areaName'].toString(),
                  additionalInfo: addressDoc['additionalInfo'].toString(),
                  isPrimary: addressDoc['isPrimary'] as bool,
                  addressId: address.id),
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
    return addressesList;
  }

  Future<List<AddressItem>> setPrimaryAddress(String addressDocId) async {
    final addressesList = <AddressItem>[];
    try {
      await firestoreUserRef.collection('addresses').get().then(
        (addressesSnapshot) {
          for (var address in addressesSnapshot.docs) {
            if (address.id == addressDocId) {
              firestoreUserRef
                  .collection('addresses')
                  .doc(address.id)
                  .update({'isPrimary': true});
            } else {
              firestoreUserRef
                  .collection('addresses')
                  .doc(address.id)
                  .update({'isPrimary': false});
            }
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
    return addressesList;
  }

  Future<GeoPoint?> getPrimaryAddressLocation() async {
    try {
      final addressSnapshot = await firestoreUserRef
          .collection('addresses')
          .where('isPrimary', isEqualTo: true)
          .get();
      if (addressSnapshot.docs.isNotEmpty) {
        final addressData = addressSnapshot.docs.first.data();
        return addressData['location'] as GeoPoint;
      }
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

  Future<MedicalHistoryModel?> getMedicalHistory() async {
    try {
      final userMedicalRef = fireStore.collection('medicalHistory').doc(userId);
      final medicalSnapshot = await userMedicalRef.get();
      if (medicalSnapshot.exists) {
        final diseasesList = <DiseaseItem>[];
        final currentDiseasesDocIds = <String>[];
        final userDiseasesRef = userMedicalRef.collection('diseases');
        await userDiseasesRef.get().then((diseasesSnapshot) {
          for (var diseaseDoc in diseasesSnapshot.docs) {
            currentDiseasesDocIds.add(diseaseDoc.id);
            final diseaseData = diseaseDoc.data();
            diseasesList.add(
              DiseaseItem(
                diseaseName: diseaseData['diseaseName'].toString(),
                diseaseMedicines: diseaseData['diseaseMedicines'].toString(),
              ),
            );
          }
        });
        final medicalDoc = medicalSnapshot.data()!;
        return MedicalHistoryModel(
          bloodType: medicalDoc['bloodType'].toString(),
          diabetic: medicalDoc['diabetic'].toString(),
          hypertensive: medicalDoc['hypertensive'].toString(),
          heartPatient: medicalDoc['heartPatient'].toString(),
          medicalAdditionalInfo: medicalDoc['medicalAdditionalInfo'].toString(),
          diseasesList: diseasesList,
          currentDiseasesDocIds: currentDiseasesDocIds,
        );
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return null;
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

  Future<AddressItem?> addNewAddress({
    required String locationName,
    required String streetName,
    required String apartmentNumber,
    required String floorNumber,
    required String areaName,
    required GeoPoint location,
    required String additionalInfo,
    required bool isPrimary,
  }) async {
    try {
      final docRef = await firestoreUserRef.collection('addresses').add({
        'locationName': locationName,
        'streetName': streetName,
        'apartmentNumber': apartmentNumber,
        'floorNumber': floorNumber,
        'areaName': areaName,
        'additionalInfo': additionalInfo,
        'location': location,
        'isPrimary': isPrimary,
      });
      return AddressItem(
        addressId: docRef.id,
        locationName: locationName,
        streetName: streetName,
        apartmentNumber: apartmentNumber,
        floorNumber: floorNumber,
        areaName: areaName,
        isPrimary: isPrimary,
        additionalInfo: additionalInfo,
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

  Future<FunctionStatus> sendCriticalUserRequest() async {
    try {
      await fireStore
          .collection('criticalUserRequests')
          .doc(userId)
          .set(<String, dynamic>{});
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

  Future<List<RequestHistoryModel>?> getRecentRequests() async {
    final List<RequestHistoryModel> readRequestsHistory = [];
    try {
      final pendingSnapshot =
          await firestoreUserRef.collection('pendingRequests').get();
      final assignedSnapshot =
          await firestoreUserRef.collection('assignedRequests').get();
      final completedSnapshot =
          await firestoreUserRef.collection('completedRequests').get();
      final canceledSnapshot =
          await firestoreUserRef.collection('canceledRequests').get();

      // Process pending requests
      for (DocumentSnapshot pendingDoc in pendingSnapshot.docs) {
        final pendingRequestDocument = await fireStore
            .collection('pendingRequests')
            .doc(pendingDoc.id)
            .get();
        if (pendingRequestDocument.exists) {
          final hospitalLocationPoint =
              pendingRequestDocument['hospitalLocation'] as GeoPoint;
          final requestLocationPoint =
              pendingRequestDocument['requestLocation'] as GeoPoint;
          final status = pendingRequestDocument['status'].toString();
          final timeStamp = pendingRequestDocument['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timeStamp);
          final requestLocation = LatLng(
              requestLocationPoint.latitude, requestLocationPoint.longitude);
          final hospitalLocation = LatLng(
              hospitalLocationPoint.latitude, hospitalLocationPoint.longitude);
          final requestModel = RequestHistoryModel(
            requestId: pendingDoc.id,
            timestamp: timeStamp,
            hospitalLocation: hospitalLocation,
            requestLocation: requestLocation,
            userId: pendingRequestDocument['userId'].toString(),
            hospitalId: pendingRequestDocument['hospitalId'].toString(),
            hospitalName: pendingRequestDocument['hospitalName'].toString(),
            isUser: pendingRequestDocument['isUser'] as bool,
            patientCondition:
                pendingRequestDocument['patientCondition'].toString(),
            backupNumber: pendingRequestDocument['backupNumber'].toString(),
            requestStatus: status == 'pending'
                ? RequestStatus.pending
                : RequestStatus.accepted,
            requestDateTime: requestDateTime,
            hospitalGeohash:
                pendingRequestDocument['hospitalGeohash'].toString(),
          );
          readRequestsHistory.add(requestModel);
        }
      }

      // Process assigned requests
      for (DocumentSnapshot assignedDoc in assignedSnapshot.docs) {
        final assignedRequestDocument = await fireStore
            .collection('assignedRequests')
            .doc(assignedDoc.id)
            .get();
        if (assignedRequestDocument.exists) {
          final hospitalLocationPoint =
              assignedRequestDocument['hospitalLocation'] as GeoPoint;
          final requestLocationPoint =
              assignedRequestDocument['requestLocation'] as GeoPoint;
          final timeStamp = assignedRequestDocument['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timeStamp);
          final requestLocation = LatLng(
              requestLocationPoint.latitude, requestLocationPoint.longitude);
          final hospitalLocation = LatLng(
              hospitalLocationPoint.latitude, hospitalLocationPoint.longitude);
          final status = assignedRequestDocument['status'].toString();
          final requestModel = RequestHistoryModel(
            requestId: assignedDoc.id,
            timestamp: timeStamp,
            hospitalLocation: hospitalLocation,
            requestLocation: requestLocation,
            userId: assignedRequestDocument['userId'].toString(),
            hospitalId: assignedRequestDocument['hospitalId'].toString(),
            hospitalName: assignedRequestDocument['hospitalName'].toString(),
            isUser: assignedRequestDocument['isUser'] as bool,
            patientCondition:
                assignedRequestDocument['patientCondition'].toString(),
            backupNumber: assignedRequestDocument['backupNumber'].toString(),
            ambulanceCarID:
                assignedRequestDocument['ambulanceCarID'].toString(),
            ambulanceDriverID:
                assignedRequestDocument['ambulanceDriverID'].toString(),
            ambulanceMedicID:
                assignedRequestDocument['ambulanceMedicID'].toString(),
            requestStatus: status == 'assigned'
                ? RequestStatus.assigned
                : RequestStatus.ongoing,
            requestDateTime: requestDateTime,
            hospitalGeohash:
                assignedRequestDocument['hospitalGeohash'].toString(),
          );
          readRequestsHistory.add(requestModel);
        }
      }

      // Process completed requests
      for (DocumentSnapshot completedDoc in completedSnapshot.docs) {
        final completedRequestDocument = await fireStore
            .collection('completedRequests')
            .doc(completedDoc.id)
            .get();
        if (completedRequestDocument.exists) {
          final hospitalLocationPoint =
              completedRequestDocument['hospitalLocation'] as GeoPoint;
          final requestLocationPoint =
              completedRequestDocument['requestLocation'] as GeoPoint;
          final timeStamp = completedRequestDocument['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timeStamp);
          final requestLocation = LatLng(
              requestLocationPoint.latitude, requestLocationPoint.longitude);
          final hospitalLocation = LatLng(
              hospitalLocationPoint.latitude, hospitalLocationPoint.longitude);
          final requestModel = RequestHistoryModel(
            requestId: completedDoc.id,
            timestamp: timeStamp,
            hospitalLocation: hospitalLocation,
            requestLocation: requestLocation,
            userId: completedRequestDocument['userId'].toString(),
            hospitalId: completedRequestDocument['hospitalId'].toString(),
            hospitalName: completedRequestDocument['hospitalName'].toString(),
            isUser: completedRequestDocument['isUser'] as bool,
            patientCondition:
                completedRequestDocument['patientCondition'].toString(),
            ambulanceCarID:
                completedRequestDocument['ambulanceCarID'].toString(),
            ambulanceDriverID:
                completedRequestDocument['ambulanceDriverID'].toString(),
            ambulanceMedicID:
                completedRequestDocument['ambulanceMedicID'].toString(),
            backupNumber: completedRequestDocument['backupNumber'].toString(),
            requestStatus: RequestStatus.completed,
            requestDateTime: requestDateTime,
            hospitalGeohash:
                completedRequestDocument['hospitalGeohash'].toString(),
          );
          readRequestsHistory.add(requestModel);
        }
      }

      // Process canceled requests
      for (DocumentSnapshot canceledDoc in canceledSnapshot.docs) {
        final canceledRequestDocument = await fireStore
            .collection('canceledRequests')
            .doc(canceledDoc.id)
            .get();
        if (canceledRequestDocument.exists) {
          final hospitalLocationPoint =
              canceledRequestDocument['hospitalLocation'] as GeoPoint;
          final requestLocationPoint =
              canceledRequestDocument['requestLocation'] as GeoPoint;
          final timeStamp = canceledRequestDocument['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timeStamp);
          final requestLocation = LatLng(
              requestLocationPoint.latitude, requestLocationPoint.longitude);
          final hospitalLocation = LatLng(
              hospitalLocationPoint.latitude, hospitalLocationPoint.longitude);
          final requestModel = RequestHistoryModel(
            requestId: canceledDoc.id,
            timestamp: timeStamp,
            hospitalLocation: hospitalLocation,
            requestLocation: requestLocation,
            userId: canceledRequestDocument['userId'].toString(),
            hospitalId: canceledRequestDocument['hospitalId'].toString(),
            hospitalName: canceledRequestDocument['hospitalName'].toString(),
            isUser: canceledRequestDocument['isUser'] as bool,
            patientCondition:
                canceledRequestDocument['patientCondition'].toString(),
            backupNumber: canceledRequestDocument['backupNumber'].toString(),
            cancelReason: canceledRequestDocument['cancelReason'].toString(),
            requestStatus: RequestStatus.canceled,
            requestDateTime: requestDateTime,
          );
          readRequestsHistory.add(requestModel);
        }
      }
      // Sort the list by timestamp
      readRequestsHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return readRequestsHistory;
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
      await user.updateDisplayName(accountDetails.name);
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
  }) async {
    try {
      final userDataBatch = fireStore.batch();
      userDataBatch.update(firestoreMedicalRef, medicalHistoryData.toJson());
      if (medicalHistoryData.currentDiseasesDocIds != null) {
        for (String diseaseDocId in medicalHistoryData.currentDiseasesDocIds!) {
          userDataBatch.delete(fireStoreUserDiseasesRef.doc(diseaseDocId));
        }
      }
      if (medicalHistoryData.diseasesList.isNotEmpty) {
        for (DiseaseItem diseaseItem in medicalHistoryData.diseasesList) {
          {
            final diseaseRef = fireStoreUserDiseasesRef.doc();
            userDataBatch.set(diseaseRef, diseaseItem.toJson());
          }
        }
      }
      userDataBatch
          .delete(fireStore.collection('criticalUserRequests').doc(userId));
      userDataBatch.delete(
          fireStore.collection('declinedCriticalUserRequests').doc(userId));
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

  Future<String?> makeSosRequest({
    required GeoPoint requestLocation,
  }) async {
    try {
      final sosRequestRef = await fireStore.collection('sosRequests').add({
        'userId': userId,
        'requestLocation': requestLocation,
        'timestamp': Timestamp.now(),
      });
      return sosRequestRef.id;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
      return null;
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
      return null;
    }
  }

  Future<FunctionStatus> cancelSosRequest() async {
    try {
      final sosRequestsRef = fireStore.collection('sosRequests');
      await sosRequestsRef
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot snapshot) async {
        for (final document in snapshot.docs) {
          final sosRequestId = document.id;
          final blockedHospitalsRef =
              sosRequestsRef.doc(sosRequestId).collection('blockedHospitals');
          final batch = fireStore.batch();
          batch.delete(document.reference);
          final blockedHospitalDocuments = await blockedHospitalsRef.get();
          for (final blockedHospital in blockedHospitalDocuments.docs) {
            batch.delete(blockedHospital.reference);
          }
          final canceledSosRequestRef =
              fireStore.collection('canceledSosRequests').doc(sosRequestId);
          batch.set(canceledSosRequestRef, {'userId': userId});
          await batch.commit();
        }
      });
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

  Future<bool?> checkUserHasSosRequest() async {
    try {
      final sosExist = await fireStore
          .collection('sosRequests')
          .where('userId', isEqualTo: userId)
          .get();
      if (sosExist.docs.isNotEmpty) {
        return true;
      }
      final sosPendingExist = await fireStore
          .collection('pendingRequests')
          .where('userId', isEqualTo: userId)
          .where('patientCondition', isEqualTo: 'sosRequest')
          .get();
      if (sosPendingExist.docs.isNotEmpty) {
        return true;
      }
      final sosAssignedExist = await fireStore
          .collection('assignedRequests')
          .where('userId', isEqualTo: userId)
          .where('patientCondition', isEqualTo: 'sosRequest')
          .get();
      if (sosAssignedExist.docs.isNotEmpty) {
        return true;
      }
      return false;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
      return null;
    }
    return null;
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
      final blockedHospitalsRef =
          requestInfo.requestRef.collection('blockedHospitals');
      final blockedHospitalDocuments = await blockedHospitalsRef.get();
      for (final blockedHospital in blockedHospitalDocuments.docs) {
        cancelRequestBatch.delete(blockedHospital.reference);
      }
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

  Future<LatLng?> getAmbulanceLocation(
      {required String ambulanceDriverId}) async {
    try {
      final snapshot = await fireStore
          .collection('driversLocations')
          .doc(ambulanceDriverId)
          .get();
      if (snapshot.exists) {
        final ambulanceLocation =
            snapshot.data()!['position']['geopoint'] as GeoPoint;
        return LatLng(ambulanceLocation.latitude, ambulanceLocation.longitude);
      }
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

  //(reminder for me) remember to modify to return all the latest request model data and that if it's not found it's not completed it may be sos request
  Future<RequestHistoryModel?> getRequestStatus(
      {required RequestHistoryModel requestModel}) async {
    try {
      final initialRequestStatus = requestModel.requestStatus;
      if (requestModel.requestStatus == RequestStatus.pending ||
          requestModel.requestStatus == RequestStatus.accepted) {
        final snapshot = await fireStore
            .collection('pendingRequests')
            .doc(requestModel.requestId)
            .get();
        if (snapshot.exists) {
          final status = snapshot.data()!['status'].toString();
          final hospitalGeohash =
              snapshot.data()!['hospitalGeohash'].toString();
          final hospitalId = snapshot.data()!['hospitalId'].toString();
          final hospitalLocation =
              snapshot.data()!['hospitalLocation'] as GeoPoint;
          final hospitalName = snapshot.data()!['hospitalName'].toString();
          final timestamp = snapshot.data()!['timestamp'] as Timestamp;
          requestModel.hospitalId = hospitalId;
          requestModel.hospitalGeohash = hospitalGeohash;
          requestModel.hospitalLocation =
              LatLng(hospitalLocation.latitude, hospitalLocation.longitude);
          requestModel.hospitalName = hospitalName;
          requestModel.timestamp = timestamp;
          if (!requestModel.isUser) {
            final diseasesRef = fireStore
                .collection('pendingRequests')
                .doc(requestModel.requestId)
                .collection('diseases');
            final diseasesList = <DiseaseItem>[];
            await diseasesRef.get().then((diseasesSnapshot) {
              for (var diseaseDoc in diseasesSnapshot.docs) {
                final diseaseData = diseaseDoc.data();
                diseasesList.add(
                  DiseaseItem(
                    diseaseName: diseaseData['diseaseName'].toString(),
                    diseaseMedicines:
                        diseaseData['diseaseMedicines'].toString(),
                  ),
                );
              }
            });
            final medicalHistory = MedicalHistoryModel(
              bloodType: snapshot.data()!['bloodType'].toString(),
              diabetic: snapshot.data()!['diabetic'].toString(),
              hypertensive: snapshot.data()!['hypertensive'].toString(),
              heartPatient: snapshot.data()!['heartPatient'].toString(),
              medicalAdditionalInfo:
                  snapshot.data()!['additionalInformation'].toString(),
              diseasesList: diseasesList,
            );
            requestModel.medicalHistory = medicalHistory;
          }
          if (status == 'pending') {
            requestModel.requestStatus = RequestStatus.pending;
          } else {
            requestModel.requestStatus = RequestStatus.accepted;
          }
          return requestModel;
        } else {
          final snapshot = await fireStore
              .collection('canceledRequests')
              .doc(requestModel.requestId)
              .get();
          if (snapshot.exists) {
            final hospitalGeohash =
                snapshot.data()!['hospitalGeohash'].toString();
            final hospitalId = snapshot.data()!['hospitalId'].toString();
            final hospitalLocation =
                snapshot.data()!['hospitalLocation'] as GeoPoint;
            final hospitalName = snapshot.data()!['hospitalName'].toString();
            final timestamp = snapshot.data()!['timestamp'] as Timestamp;
            requestModel.hospitalId = hospitalId;
            requestModel.hospitalGeohash = hospitalGeohash;
            requestModel.hospitalLocation =
                LatLng(hospitalLocation.latitude, hospitalLocation.longitude);
            requestModel.hospitalName = hospitalName;
            requestModel.timestamp = timestamp;
            if (initialRequestStatus != RequestStatus.canceled) {
              requestModel.requestStatus = RequestStatus.canceled;
              requestModel.cancelReason =
                  snapshot.data()!['cancelReason'].toString();
              return requestModel;
            }
          } else {
            requestModel.requestStatus = RequestStatus.assigned;
          }
        }
      }
      if (requestModel.requestStatus == RequestStatus.assigned ||
          requestModel.requestStatus == RequestStatus.ongoing) {
        final snapshot = await fireStore
            .collection('assignedRequests')
            .doc(requestModel.requestId)
            .get();
        if (snapshot.exists) {
          final snapData = snapshot.data()!;
          final status = snapData['status'].toString();
          final hospitalGeohash = snapData['hospitalGeohash'].toString();
          final hospitalId = snapData['hospitalId'].toString();
          final hospitalLocation = snapData['hospitalLocation'] as GeoPoint;
          final hospitalName = snapData['hospitalName'].toString();
          final timestamp = snapData['timestamp'] as Timestamp;
          requestModel.hospitalId = hospitalId;
          requestModel.hospitalGeohash = hospitalGeohash;
          requestModel.hospitalLocation =
              LatLng(hospitalLocation.latitude, hospitalLocation.longitude);
          requestModel.hospitalName = hospitalName;
          requestModel.timestamp = timestamp;
          requestModel.ambulanceDriverID =
              snapData['ambulanceDriverID'].toString();
          requestModel.ambulanceCarID = snapData['ambulanceCarID'].toString();
          requestModel.ambulanceMedicID =
              snapData['ambulanceMedicID'].toString();
          if (!requestModel.isUser) {
            final diseasesRef = fireStore
                .collection('pendingRequests')
                .doc(requestModel.requestId)
                .collection('diseases');
            final diseasesList = <DiseaseItem>[];
            await diseasesRef.get().then((diseasesSnapshot) {
              for (var diseaseDoc in diseasesSnapshot.docs) {
                final diseaseData = diseaseDoc.data();
                diseasesList.add(
                  DiseaseItem(
                    diseaseName: diseaseData['diseaseName'].toString(),
                    diseaseMedicines:
                        diseaseData['diseaseMedicines'].toString(),
                  ),
                );
              }
            });
            final medicalHistory = MedicalHistoryModel(
              bloodType: snapData['bloodType'].toString(),
              diabetic: snapData['diabetic'].toString(),
              hypertensive: snapData['hypertensive'].toString(),
              heartPatient: snapData['heartPatient'].toString(),
              medicalAdditionalInfo:
                  snapData['additionalInformation'].toString(),
              diseasesList: diseasesList,
            );
            requestModel.medicalHistory = medicalHistory;
          }
          if (status == 'assigned') {
            requestModel.requestStatus = RequestStatus.assigned;
          } else {
            requestModel.requestStatus = RequestStatus.ongoing;
          }
          return requestModel;
        } else {
          final snapshot = await fireStore
              .collection('canceledRequests')
              .doc(requestModel.requestId)
              .get();
          if (snapshot.exists) {
            final snapData = snapshot.data()!;
            final hospitalGeohash = snapData['hospitalGeohash'].toString();
            final hospitalId = snapData['hospitalId'].toString();
            final hospitalLocation = snapData['hospitalLocation'] as GeoPoint;
            final hospitalName = snapData['hospitalName'].toString();
            final timestamp = snapData['timestamp'] as Timestamp;
            requestModel.hospitalId = hospitalId;
            requestModel.hospitalGeohash = hospitalGeohash;
            requestModel.hospitalLocation =
                LatLng(hospitalLocation.latitude, hospitalLocation.longitude);
            requestModel.hospitalName = hospitalName;
            requestModel.timestamp = timestamp;
            requestModel.requestStatus = RequestStatus.canceled;
            requestModel.cancelReason =
                snapshot.data()!['cancelReason'].toString();
          } else {
            final snapshot = await fireStore
                .collection('completedRequests')
                .doc(requestModel.requestId)
                .get();
            if (snapshot.exists) {
              final snapData = snapshot.data()!;
              final hospitalGeohash = snapData['hospitalGeohash'].toString();
              final hospitalId = snapData['hospitalId'].toString();
              final hospitalLocation = snapData['hospitalLocation'] as GeoPoint;
              final hospitalName = snapData['hospitalName'].toString();
              final timestamp = snapData['timestamp'] as Timestamp;
              requestModel.hospitalId = hospitalId;
              requestModel.hospitalGeohash = hospitalGeohash;
              requestModel.hospitalLocation =
                  LatLng(hospitalLocation.latitude, hospitalLocation.longitude);
              requestModel.hospitalName = hospitalName;
              requestModel.timestamp = timestamp;
              requestModel.requestStatus = RequestStatus.completed;
              return requestModel;
            }
          }
        }
      }
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
    if (authRep.isUserRegistered) {
      await deleteFcmToken();
    }
  }
}
