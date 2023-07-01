import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../constants/enums.dart';
import '../../../account/components/models.dart';

class HospitalModel {
  final String hospitalId;
  final String name;
  final String avgAmbulancePrice;
  final String geohash;
  final String hospitalNumber;
  final String address;
  final LatLng location;

  HospitalModel({
    required this.hospitalId,
    required this.name,
    required this.avgAmbulancePrice,
    required this.geohash,
    required this.location,
    required this.hospitalNumber,
    required this.address,
  });
}

class UserInfoRequestModel {
  final String email;
  final String name;
  final bool criticalUser;
  final String gender;
  final String backupNumber;
  final String phoneNumber;
  final String profilePicUrl;
  final int age;

  UserInfoRequestModel({
    required this.name,
    required this.criticalUser,
    required this.email,
    required this.gender,
    required this.profilePicUrl,
    required this.backupNumber,
    required this.phoneNumber,
    required this.age,
  });
}

class EmployeeRequestDataModel {
  final String requestId;
  final String userId;
  final String additionalInformation;
  final String phoneNumber;
  final String? patientAge;
  final String hospitalId;
  final String hospitalName;
  final String backupNumber;
  final String patientCondition;
  final RxString mapUrl = ''.obs;
  RequestStatus requestStatus;
  final bool isUser;
  bool notifiedNear;
  bool notifiedArrived;
  bool notifiedOngoing;
  final LatLng requestLocation;
  final LatLng hospitalLocation;
  final Timestamp timestamp;
  final String licensePlate;
  final String ambulanceType;
  final String ambulanceDriverID;
  final String ambulanceMedicID;
  final String ambulanceCarID;
  final MedicalHistoryModel? medicalHistory;
  final String hospitalGeohash;
  EmployeeRequestDataModel({
    required this.requestId,
    required this.userId,
    required this.backupNumber,
    required this.patientCondition,
    required this.isUser,
    required this.hospitalId,
    required this.timestamp,
    required this.hospitalName,
    required this.requestStatus,
    required this.requestLocation,
    required this.hospitalLocation,
    required this.additionalInformation,
    required this.phoneNumber,
    required this.licensePlate,
    required this.ambulanceType,
    required this.ambulanceDriverID,
    required this.ambulanceMedicID,
    required this.ambulanceCarID,
    required this.hospitalGeohash,
    required this.notifiedNear,
    required this.notifiedArrived,
    required this.notifiedOngoing,
    this.patientAge,
    this.medicalHistory,
  });
  Map<String, dynamic> toJson() => {
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'userId': userId,
        'isUser': isUser,
        'patientCondition': patientCondition,
        'backupNumber': backupNumber,
        'phoneNumber': phoneNumber,
        'timestamp': timestamp,
        'requestLocation':
            GeoPoint(requestLocation.latitude, requestLocation.longitude),
        'hospitalLocation':
            GeoPoint(hospitalLocation.latitude, hospitalLocation.longitude),
        'additionalInformation': additionalInformation,
        'requestId': requestId,
        'licensePlate': licensePlate,
        'ambulanceType': ambulanceType,
        'ambulanceDriverID': ambulanceDriverID,
        'ambulanceMedicID': ambulanceMedicID,
        'ambulanceCarID': ambulanceCarID,
        'hospitalGeohash': hospitalGeohash,
        'patientAge': patientAge,
      };
}
