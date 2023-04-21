import '../../../account/components/models.dart';

class MedicalInformation {
  final String bloodType;
  final String diabetesPatient;
  final String additionalInformation;
  final String bloodPressurePatient;
  final String heartPatient;
  final List<DiseaseItem> diseasesList;
  MedicalInformation({
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
