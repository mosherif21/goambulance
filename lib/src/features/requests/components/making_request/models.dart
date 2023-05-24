import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../account/components/models.dart';

class HospitalModel {
  final String hospitalId;
  final String name;
  final String avgPrice;
  final LatLng location;
  HospitalModel({
    required this.hospitalId,
    required this.name,
    required this.avgPrice,
    required this.location,
  });
}

class RequestInfoModel {
  final bool isUser;
  final String patientCondition;
  final String backupNumber;
  final MedicalHistoryModel? medicalHistory;
  RequestInfoModel({
    required this.isUser,
    required this.patientCondition,
    required this.backupNumber,
    this.medicalHistory,
  });
  Map<String, dynamic> toJson() => {
        'isUser': isUser,
        'patientCondition': patientCondition,
        'backupNumber': backupNumber,
      };
}

class RequestModel {
  final String patientId;
  final RequestInfoModel hospitalRequestInfo;
  final Timestamp timestamp;
  final GeoPoint location;
  final String hospitalId;
  final DocumentReference requestRef;
  RequestModel({
    required this.requestRef,
    required this.patientId,
    required this.hospitalId,
    required this.hospitalRequestInfo,
    required this.timestamp,
    required this.location,
  });
  Map<String, dynamic> toJson() => {
        'hospitalId': hospitalId,
        'patientId': patientId,
        'isUser': hospitalRequestInfo.isUser,
        'patientCondition': hospitalRequestInfo.patientCondition,
        'backupNumber': hospitalRequestInfo.backupNumber,
        'timestamp': timestamp,
        'location': location,
        'status': 'pending',
      };
}
