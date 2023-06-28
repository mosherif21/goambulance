import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/models.dart';
import 'package:goambulance/src/features/requests/components/requests_history/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../authentication/authentication_repository.dart';
import '../src/constants/enums.dart';
import '../src/features/account/components/models.dart';
import '../src/general/app_init.dart';
import '../src/general/general_functions.dart';

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
      final snapshot = await fireStore
          .collection('hospitals')
          .doc(authRep.employeeUserInfo.hospitalId)
          .get();
      if (snapshot.exists) {
        final snapshotData = snapshot.data();
        if (snapshotData != null) {
          final geoPointLocation = snapshotData['location'] as GeoPoint;
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

  Future<RequestDataModel?> getAssignedRequestInfo(
      {required String requestId}) async {
    try {
      final snapshot =
          await fireStore.collection('assignedRequests').doc(requestId).get();
      if (snapshot.exists) {
        final snapshotData = snapshot.data();
        if (snapshotData != null) {
          final requestLocation = snapshotData['requestLocation'] as GeoPoint;
          final hospitalLocation = snapshotData['hospitalLocation'] as GeoPoint;
          final requestUserId = snapshotData['userId'].toString();
          final additionalInformation =
              snapshotData['additionalInformation'].toString();
          final hospitalId = snapshotData['hospitalId'].toString();
          final backupNumber = snapshotData['backupNumber'].toString();
          final patientCondition = snapshotData['patientCondition'].toString();
          final hospitalName = snapshotData['hospitalName'].toString();
          final status = snapshotData['status'].toString();
          final patientAge = snapshotData['patientAge'].toString();
          final ambulanceType = snapshotData['ambulanceType'].toString();
          final licensePlate = snapshotData['licensePlate'].toString();
          final ambulanceDriverID =
              snapshotData['ambulanceDriverID'].toString();
          final ambulanceMedicID = snapshotData['ambulanceMedicID'].toString();
          final hospitalGeohash = snapshotData['hospitalGeohash'].toString();
          final requestStatus = status == 'assigned'
              ? RequestStatus.assigned
              : RequestStatus.ongoing;
          final isUser = snapshotData['isUser'] as bool;
          final timestamp = snapshotData['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timestamp);
          late final MedicalHistoryModel medicalHistory;
          if (isUser) {
            final medicalHistorySnapshot = await fireStore
                .collection('medicalHistory')
                .doc(requestUserId)
                .get();
            if (medicalHistorySnapshot.exists) {
              final medicalHistoryData = medicalHistorySnapshot.data()!;
              final diseasesRef = fireStore
                  .collection('medicalHistory')
                  .doc(requestUserId)
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
              medicalHistory = MedicalHistoryModel(
                bloodType: medicalHistoryData['bloodType'].toString(),
                diabetic: medicalHistoryData['diabetic'].toString(),
                hypertensive: medicalHistoryData['hypertensive'].toString(),
                heartPatient: medicalHistoryData['heartPatient'].toString(),
                medicalAdditionalInfo:
                    medicalHistoryData['medicalAdditionalInfo'].toString(),
                diseasesList: diseasesList,
              );
            }
          } else {
            final diseasesRef = fireStore
                .collection('assignedRequests')
                .doc(requestId)
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
            medicalHistory = MedicalHistoryModel(
              bloodType: snapshotData['bloodType'].toString(),
              diabetic: snapshotData['diabetic'].toString(),
              hypertensive: snapshotData['hypertensive'].toString(),
              heartPatient: snapshotData['heartPatient'].toString(),
              medicalAdditionalInfo:
                  snapshotData['medicalAdditionalInfo'].toString(),
              diseasesList: diseasesList,
            );
          }
          final requestData = RequestDataModel(
            requestId: requestId,
            userId: requestUserId,
            backupNumber: backupNumber,
            patientCondition: patientCondition,
            isUser: isUser,
            hospitalId: hospitalId,
            timestamp: timestamp,
            hospitalName: hospitalName,
            requestDateTime: requestDateTime,
            requestStatus: requestStatus,
            requestLocation:
                LatLng(requestLocation.latitude, requestLocation.longitude),
            hospitalLocation:
                LatLng(hospitalLocation.latitude, hospitalLocation.longitude),
            additionalInformation: additionalInformation,
            patientAge: patientAge,
            licensePlate: licensePlate,
            ambulanceType: ambulanceType,
            ambulanceDriverID: ambulanceDriverID,
            ambulanceMedicID: ambulanceMedicID,
            hospitalGeohash: hospitalGeohash,
            medicalHistory: medicalHistory,
          );
          return requestData;
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
