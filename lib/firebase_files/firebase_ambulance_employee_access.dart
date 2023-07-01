import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../authentication/authentication_repository.dart';
import '../src/constants/enums.dart';
import '../src/features/account/components/models.dart';
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

  Future<EmployeeRequestDataModel?> getAssignedRequestInfo(
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
          final ambulanceCarID = snapshotData['ambulanceCarID'].toString();
          final hospitalGeohash = snapshotData['hospitalGeohash'].toString();
          final phoneNumber = snapshotData['phoneNumber'].toString();

          final requestStatus = status == 'assigned'
              ? RequestStatus.assigned
              : RequestStatus.ongoing;
          final isUser = snapshotData['isUser'] as bool;
          final notifiedNear = snapshotData['notifiedNear'] as bool;
          final notifiedArrived = snapshotData['notifiedArrived'] as bool;
          final notifiedOngoing = snapshotData['notifiedOngoing'] as bool;
          final timestamp = snapshotData['timestamp'] as Timestamp;
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
          final requestData = EmployeeRequestDataModel(
            requestId: requestId,
            userId: requestUserId,
            backupNumber: backupNumber,
            patientCondition: patientCondition,
            isUser: isUser,
            hospitalId: hospitalId,
            timestamp: timestamp,
            hospitalName: hospitalName,
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
            ambulanceCarID: ambulanceCarID,
            hospitalGeohash: hospitalGeohash,
            medicalHistory: medicalHistory,
            phoneNumber: phoneNumber,
            notifiedNear: notifiedNear,
            notifiedArrived: notifiedArrived,
            notifiedOngoing: notifiedOngoing,
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

  Future<List<NotificationItem>?> getNotifications() async {
    try {
      final userNotificationRef =
          fireStore.collection('notifications').doc(userId);
      final notificationSnapshot = await userNotificationRef.get();
      final notificationList = <NotificationItem>[];
      if (notificationSnapshot.exists) {
        final userNRef = userNotificationRef.collection('messages');
        await userNRef.get().then((notificationSnapshot) {
          for (var notificationDoc in notificationSnapshot.docs) {
            final notificationData = notificationDoc.data();
            notificationList.add(
              NotificationItem(
                title: notificationData['title'].toString(),
                body: notificationData['body'].toString(),
                timestamp: notificationData['timestamp'],
              ),
            );
          }
        });

        notificationList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      return notificationList;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return null;
  }

  Future<FunctionStatus> sendNotification({
    required String userId,
    required String hospitalName,
    required EmployeeNotificationType notificationType,
    required String requestId,
  }) async {
    final url = Uri.parse(
        'https://us-central1-ambulancebookingproject.cloudfunctions.net/sendNotification');
    final headers = {'Content-Type': 'application/json'};
    final notificationTypeParam =
        notificationType == EmployeeNotificationType.ambulanceNear
            ? 'ambulanceNear'
            : notificationType == EmployeeNotificationType.ambulanceArrived
                ? 'ambulanceArrived'
                : 'requestOngoing';
    final body = json.encode({
      'notificationType': notificationTypeParam,
      'userId': userId,
      'hospitalName': hospitalName,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        await updateAssignedNotificationsVars(
            notificationType: notificationType, requestId: requestId);
        if (kDebugMode) {
          AppInit.logger.i(
              'Notifications called with type: $notificationType and response: ${response.body}');
        }
        return FunctionStatus.success;
      } else {
        if (kDebugMode) {
          AppInit.logger.e('Notifications send failed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e('Notifications send failed ${e.toString()}');
      }
    }
    return FunctionStatus.failure;
  }

  Future<void> updateAssignedNotificationsVars({
    required EmployeeNotificationType notificationType,
    required String requestId,
  }) async {
    try {
      await fireStore.collection('assignedRequests').doc(requestId).update({
        notificationType == EmployeeNotificationType.ambulanceNear
            ? 'notifiedNear'
            : notificationType == EmployeeNotificationType.ambulanceArrived
                ? 'notifiedArrived'
                : 'notifiedOngoing': true
      });
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  Future<void> resetNotificationCount() async {
    try {
      await fireStore
          .collection('notifications')
          .doc(userId)
          .set({'unseenCount': 0});
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  Future<void> updateDriverLocation({required GeoPoint driverLocation}) async {
    try {
      await fireStore
          .collection('driversLocations')
          .doc(userId)
          .set({'location': driverLocation});
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  Future<FunctionStatus> confirmPickup({required String requestId}) async {
    try {
      final assignedRequestRef =
          fireStore.collection('assignedRequests').doc(requestId);
      await assignedRequestRef.update({'status': 'ongoing'});
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return FunctionStatus.failure;
  }

  Future<FunctionStatus> completeRequest(
      {required EmployeeRequestDataModel requestInfo}) async {
    try {
      final assignedRequestRef =
          fireStore.collection('assignedRequests').doc(requestInfo.requestId);
      final completedRequestRef =
          fireStore.collection('completedRequests').doc(requestInfo.requestId);
      final completeRequestBatch = fireStore.batch();
      completeRequestBatch.delete(assignedRequestRef);
      completeRequestBatch.set(completedRequestRef, requestInfo.toJson());
      if (!requestInfo.isUser) {
        final medicalHistory = requestInfo.medicalHistory;
        if (medicalHistory != null) {
          completeRequestBatch.update(
              completedRequestRef, medicalHistory.toJson());
          if (medicalHistory.diseasesList.isNotEmpty) {
            final diseasesRef = assignedRequestRef.collection('diseases');
            final completedDiseasesRef =
                completedRequestRef.collection('diseases');
            await diseasesRef.get().then((diseasesSnapshot) {
              for (var diseaseDoc in diseasesSnapshot.docs) {
                final diseaseDocId = diseaseDoc.id;
                final diseaseData = diseaseDoc.data();
                final diseaseItem = DiseaseItem(
                  diseaseName: diseaseData['diseaseName'].toString(),
                  diseaseMedicines: diseaseData['diseaseMedicines'].toString(),
                );
                completeRequestBatch.delete(diseaseDoc.reference);
                completeRequestBatch.set(completedDiseasesRef.doc(diseaseDocId),
                    diseaseItem.toJson());
              }
            });
          }
        }
      }
      completeRequestBatch.delete(firestoreUserRef
          .collection('assignedRequests')
          .doc(requestInfo.requestId));
      completeRequestBatch.set(
          firestoreUserRef
              .collection('completedRequests')
              .doc(requestInfo.requestId),
          <String, dynamic>{});

      final driverHospitalAssignedRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('assignedAmbulanceDrivers')
          .doc(requestInfo.ambulanceDriverID);
      final medicHospitalAssignedRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('assignedAmbulanceMedics')
          .doc(requestInfo.ambulanceMedicID);
      final carHospitalAssignedRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('assignedAmbulanceCars')
          .doc(requestInfo.ambulanceCarID);
      completeRequestBatch.delete(driverHospitalAssignedRef);
      completeRequestBatch.delete(medicHospitalAssignedRef);
      completeRequestBatch.delete(carHospitalAssignedRef);
      final driverHospitalAvailableRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('availableAmbulanceDrivers')
          .doc(requestInfo.ambulanceDriverID);
      final medicHospitalAvailableRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('availableAmbulanceMedics')
          .doc(requestInfo.ambulanceMedicID);
      final carHospitalAvailableRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('availableAmbulanceCars')
          .doc(requestInfo.ambulanceCarID);
      completeRequestBatch.set(driverHospitalAvailableRef, <String, dynamic>{});
      completeRequestBatch.set(medicHospitalAvailableRef, <String, dynamic>{});
      completeRequestBatch.set(carHospitalAvailableRef, <String, dynamic>{
        'type': requestInfo.ambulanceType,
        'licensePlate': requestInfo.licensePlate,
      });
      final hospitalAssignedRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('assignedRequests')
          .doc(requestInfo.requestId);
      completeRequestBatch.delete(hospitalAssignedRef);
      final hospitalCompletedRef = fireStore
          .collection('hospitals')
          .doc(requestInfo.hospitalId)
          .collection('completedRequests')
          .doc(requestInfo.requestId);
      completeRequestBatch.set(hospitalCompletedRef, <String, dynamic>{});

      final medicAssignedRef = fireStore
          .collection('users')
          .doc(requestInfo.ambulanceMedicID)
          .collection('assignedRequests')
          .doc(requestInfo.requestId);
      completeRequestBatch.delete(medicAssignedRef);
      final medicCompletedRef = fireStore
          .collection('users')
          .doc(requestInfo.ambulanceMedicID)
          .collection('assignedRequests')
          .doc(requestInfo.requestId);
      completeRequestBatch.set(medicCompletedRef, <String, dynamic>{});
      final userAssignedRef = fireStore
          .collection('users')
          .doc(requestInfo.userId)
          .collection('assignedRequests')
          .doc(requestInfo.requestId);
      completeRequestBatch.delete(userAssignedRef);
      final userCompletedRef = fireStore
          .collection('users')
          .doc(requestInfo.userId)
          .collection('assignedRequests')
          .doc(requestInfo.requestId);
      completeRequestBatch.set(userCompletedRef, <String, dynamic>{});

      await completeRequestBatch.commit();
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return FunctionStatus.failure;
  }

  Future<UserInfoRequestModel?> getUserInfo({required String userId}) async {
    try {
      final snapshot = await fireStore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        final snapshotData = snapshot.data();
        if (snapshotData != null) {
          final age = (DateTime.now()
                  .difference((snapshotData['birthdate'] as Timestamp).toDate())
                  .inDays ~/
              365);
          final userProfilePicUrl = await getUserProfilePicUrl(userId: userId);
          final userInfoRequest = UserInfoRequestModel(
            name: snapshotData['name'].toString(),
            criticalUser: snapshotData['criticalUser'] as bool,
            email: snapshotData['email'].toString(),
            gender: snapshotData['gender'].toString(),
            backupNumber: snapshotData['backupNumber'].toString(),
            phoneNumber: snapshotData['phoneNumber'].toString(),
            age: age,
            profilePicUrl: userProfilePicUrl,
          );
          return userInfoRequest;
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

  Future<void> deleteDriversLocation() async {
    try {
      await fireStore.collection('driversLocations').doc(userId).delete();
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

  Future<String> getUserProfilePicUrl({required String userId}) async {
    try {
      return await fireStorage
          .ref()
          .child('users')
          .child(userId)
          .child('profilePic')
          .getDownloadURL();
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
    }
    return '';
  }

  Future<void> logoutFirebase() async {
    if (authRep.isUserRegistered) {
      await deleteFcmToken();
    }
    await deleteDriversLocation();
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
