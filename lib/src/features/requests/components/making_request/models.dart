import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../account/components/models.dart';

class MedicalHistoryModel {
  final String bloodType;
  final String diabetesPatient;
  final String additionalInformation;
  final String bloodPressurePatient;
  final String heartPatient;
  final List<DiseaseItem> diseasesList;
  MedicalHistoryModel({
    required this.bloodType,
    required this.diabetesPatient,
    required this.bloodPressurePatient,
    required this.heartPatient,
    required this.additionalInformation,
    required this.diseasesList,
  });
  Map<String, dynamic> toJson() => {
        'bloodType': bloodType,
        'diabetesPatient': diabetesPatient,
        'bloodPressurePatient': bloodPressurePatient,
        'heartPatient': heartPatient,
        'additionalInformation': additionalInformation,
      };
}

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

class HospitalRequest {
  final String hospitalId;
  final String patientId;
  final String relationToPatient;
  final String patientCondition;
  final String backupNumber;
  final Timestamp timestamp;
  final LatLng location;
  final MedicalHistoryModel medicalHistory;
  HospitalRequest({
    required this.hospitalId,
    required this.patientId,
    required this.relationToPatient,
    required this.patientCondition,
    required this.backupNumber,
    required this.timestamp,
    required this.location,
    required this.medicalHistory,
  });
  Map<String, dynamic> toJson() => {
        'hospitalId': hospitalId,
        'patientId': patientId,
        'relationToPatient': relationToPatient,
        'patientCondition': patientCondition,
        'backupNumber': backupNumber,
        'timestamp': timestamp,
        'location': location,
      };
}
