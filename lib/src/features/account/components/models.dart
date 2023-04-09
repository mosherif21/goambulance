class UserInfo {
  final String name;
  final String email;
  final String nationalId;
  final DateTime birthDate;
  final String gender;
  final String bloodType;
  final String diabetesPatient;
  final String additionalInformation;
  final bool bloodPressurePatient;
  final bool heartPatient;
  final List<DiseaseItem> diseasesList;
  UserInfo({
    required this.name,
    required this.email,
    required this.nationalId,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.diabetesPatient,
    required this.bloodPressurePatient,
    required this.heartPatient,
    required this.additionalInformation,
    required this.diseasesList,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'nationalId': nationalId,
        'birthdate': birthDate,
        'gender': gender,
        'bloodType': bloodType,
        'diabetesPatient': diabetesPatient,
        'bloodPressurePatient': bloodPressurePatient ? 'Yes' : 'No',
        'heartPatient': heartPatient ? 'Yes' : 'No',
        'additionalInformation': additionalInformation,
        'criticalUser': false,
        'type': 'patient',
      };
}

class DiseaseItem {
  final String diseaseName;
  final String diseaseMedicines;
  DiseaseItem({
    required this.diseaseName,
    required this.diseaseMedicines,
  });
  Map<String, dynamic> toJson() {
    return {
      'diseaseName': diseaseName,
      'diseaseMedicines': diseaseMedicines,
    };
  }
}

final List<String> bloodTypes = [
  'A+',
  'O+',
  'B+',
  'AB+',
  'A-',
  'O-',
  'B-',
  'AB-',
];
