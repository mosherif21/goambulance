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
  final String relationToPatient;
  final String patientCondition;
  final String backupNumber;
  final MedicalHistoryModel? medicalHistory;
  RequestInfoModel({
    required this.relationToPatient,
    required this.patientCondition,
    required this.backupNumber,
    this.medicalHistory,
  });
  Map<String, dynamic> toJson() => {
        'relationToPatient': relationToPatient,
        'patientCondition': patientCondition,
        'backupNumber': backupNumber,
      };
}

class RequestModel {
  final String patientId;
  final RequestInfoModel hospitalRequestInfo;
  final Timestamp timestamp;
  final LatLng location;
  final String hospitalId;
  RequestModel({
    required this.patientId,
    required this.hospitalId,
    required this.hospitalRequestInfo,
    required this.timestamp,
    required this.location,
  });
  Map<String, dynamic> toJson() => {
        'hospitalId': hospitalId,
        'patientId': patientId,
        'relationToPatient': hospitalRequestInfo.relationToPatient,
        'patientCondition': hospitalRequestInfo.patientCondition,
        'backupNumber': hospitalRequestInfo.backupNumber,
        'timestamp': timestamp,
        'location': location,
      };
}
