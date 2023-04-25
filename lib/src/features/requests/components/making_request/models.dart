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
  final int timeFromLocation;
  HospitalModel({
    required this.hospitalId,
    required this.name,
    required this.avgPrice,
    required this.location,
    required this.timeFromLocation,
  });
}
