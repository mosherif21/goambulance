class UserInformation {
  final String name;
  final String email;
  final String nationalId;
  final DateTime birthDate;
  final String gender;
  final String bloodType;
  final String diabetesPatient;
  final String additionalInformation;
  final String phoneNumber;
  final String hypertensive;
  final String heartPatient;
  final List<DiseaseItem> diseasesList;
  UserInformation({
    required this.name,
    required this.email,
    required this.nationalId,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.diabetesPatient,
    required this.hypertensive,
    required this.heartPatient,
    required this.additionalInformation,
    required this.phoneNumber,
    required this.diseasesList,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'nationalId': nationalId,
        'phoneNo': phoneNumber,
        'birthdate': birthDate,
        'gender': gender,
        'bloodType': bloodType,
        'diabetic': diabetesPatient,
        'hypertensive': hypertensive,
        'heartPatient': heartPatient,
        'additionalInformation': additionalInformation,
        'type': 'patient',
        'criticalUser': false,
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
