import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../account/components/models.dart';

class HospitalModel {
  final String hospitalId;
  final String name;
  final String avgPrice;
  final String geohash;
  final LatLng location;

  HospitalModel({
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
  final MedicalHistoryModel? medicalHistory;
  final bool? sendSms;
  RequestInfoModel({
    required this.isUser,
    required this.patientCondition,
    required this.backupNumber,
    this.sendSms,
    this.medicalHistory,
  });
  Map<String, dynamic> toJson() => {
        'isUser': isUser,
        'patientCondition': patientCondition,
        'backupNumber': backupNumber,
      };
}

class RequestModel {
  final String userId;
  final RequestInfoModel hospitalRequestInfo;
  final Timestamp timestamp;
  final GeoPoint requestLocation;
  final GeoPoint hospitalLocation;
  final String hospitalGeohash;
  final String hospitalId;
  final String hospitalName;
  final String status;
  final DocumentReference requestRef;
  RequestModel({
    required this.requestRef,
    required this.userId,
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalRequestInfo,
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
        'isUser': hospitalRequestInfo.isUser,
        'patientCondition': hospitalRequestInfo.patientCondition,
        'backupNumber': hospitalRequestInfo.backupNumber,
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
  });
  Map<String, dynamic> toJson() => {
        'hospitalId': hospitalId,
        'hospitalName': hospitalName,
        'userId': userId,
        'isUser': hospitalRequestInfo.isUser,
        'patientCondition': hospitalRequestInfo.patientCondition,
        'backupNumber': hospitalRequestInfo.backupNumber,
        'timestamp': timestamp,
        'requestLocation': requestLocation,
        'hospitalLocation': hospitalLocation,
        'cancelReason': cancelReason,
      };
}
