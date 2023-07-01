import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/enums.dart';
import '../../account/components/models.dart';

class HospitalLocationsModel {
  final String hospitalId;
  final String name;
  final String avgPrice;
  final String geohash;
  final LatLng location;

  HospitalLocationsModel({
    required this.hospitalId,
    required this.name,
    required this.avgPrice,
    required this.geohash,
    required this.location,
  });
}

class RequestInfoModel {
  final bool isUser;
  final String patientCondition;
  final String backupNumber;
  final String phoneNumber;
  final String additionalInformation;
  final MedicalHistoryModel? medicalHistory;
  final bool? sendSms;
  final String patientAge;
  RequestInfoModel({
    required this.isUser,
    required this.patientCondition,
    required this.backupNumber,
    required this.additionalInformation,
    required this.patientAge,
    required this.phoneNumber,
    this.sendSms,
    this.medicalHistory,
  });
}

class RequestMakingModel {
  final String userId;
  final RequestInfoModel requestInfo;
  final Timestamp timestamp;
  final GeoPoint requestLocation;
  final GeoPoint hospitalLocation;
  final String hospitalGeohash;
  final String hospitalId;
  final String hospitalName;
  final String status;
  final DocumentReference requestRef;
  RequestMakingModel({
    required this.requestRef,
    required this.userId,
    required this.hospitalId,
    required this.hospitalName,
    required this.requestInfo,
    required this.timestamp,
    required this.status,
    required this.requestLocation,
    required this.hospitalLocation,
    required this.hospitalGeohash,
  });
  Map<String, dynamic> toJson() => {
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'userId': userId,
        'isUser': requestInfo.isUser,
        'patientCondition': requestInfo.patientCondition,
        'backupNumber': requestInfo.backupNumber,
        'additionalInformation': requestInfo.additionalInformation,
        'patientAge': requestInfo.patientAge,
        'phoneNumber': requestInfo.phoneNumber,
        'timestamp': timestamp,
        'requestLocation': requestLocation,
        'hospitalLocation': hospitalLocation,
        'hospitalGeohash': hospitalGeohash,
        'status': status,
      };
}

class CanceledRequestModel {
  final String userId;
  final RequestInfoModel hospitalRequestInfo;
  final Timestamp timestamp;
  final GeoPoint requestLocation;
  final GeoPoint hospitalLocation;
  final String hospitalId;
  final String hospitalName;
  final String cancelReason;
  final String additionalInformation;
  final DocumentReference requestRef;
  CanceledRequestModel({
    required this.requestRef,
    required this.userId,
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalRequestInfo,
    required this.timestamp,
    required this.requestLocation,
    required this.hospitalLocation,
    required this.cancelReason,
    required this.additionalInformation,
  });
  Map<String, dynamic> toJson() => {
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'userId': userId,
        'isUser': hospitalRequestInfo.isUser,
        'patientCondition': hospitalRequestInfo.patientCondition,
        'backupNumber': hospitalRequestInfo.backupNumber,
        'phoneNumber': hospitalRequestInfo.phoneNumber,
        'timestamp': timestamp,
        'requestLocation': requestLocation,
        'hospitalLocation': hospitalLocation,
        'cancelReason': cancelReason,
        'additionalInformation': additionalInformation,
      };
}

class StaticMarkerModel {
  final LatLng location;
  final String iconUrl;

  StaticMarkerModel({
    required this.location,
    required this.iconUrl,
  });
}

class RequestHistoryDataModel {
  final String requestId;
  final String userId;
  final String additionalInformation;
  final String phoneNumber;
  String? patientAge;
  String hospitalId;
  String hospitalName;
  final String backupNumber;
  final String patientCondition;
  RxString mapUrl = ''.obs;
  final String requestDateTime;
  RequestStatus requestStatus;
  final bool isUser;
  final LatLng requestLocation;
  LatLng hospitalLocation;
  Timestamp timestamp;
  String? cancelReason;
  String? licensePlate;
  String? ambulanceType;
  String? ambulanceDriverID;
  String? ambulanceMedicID;
  String? ambulanceCarID;
  MedicalHistoryModel? medicalHistory;
  String? hospitalGeohash;
  RequestHistoryDataModel({
    required this.requestId,
    required this.userId,
    required this.backupNumber,
    required this.patientCondition,
    required this.isUser,
    required this.hospitalId,
    required this.timestamp,
    required this.hospitalName,
    required this.requestDateTime,
    required this.requestStatus,
    required this.requestLocation,
    required this.hospitalLocation,
    required this.additionalInformation,
    required this.phoneNumber,
    this.patientAge,
    this.cancelReason,
    this.licensePlate,
    this.ambulanceType,
    this.ambulanceDriverID,
    this.ambulanceMedicID,
    this.ambulanceCarID,
    this.hospitalGeohash,
    this.medicalHistory,
  });
}
