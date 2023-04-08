class UserInfoSave {
  final String name;
  final String email;
  final String nationalId;
  final DateTime birthDate;
  final String gender;
  UserInfoSave({
    required this.name,
    required this.email,
    required this.nationalId,
    required this.birthDate,
    required this.gender,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'nationalId': nationalId,
        'birthdate': birthDate,
        'gender': gender,
      };
}

class MedicalInfoSave {
  final String bloodType;
  final String diabetesPatient;
  final String additionalInformation;
  final bool bloodPressurePatient;
  final bool heartPatient;
  MedicalInfoSave({
    required this.bloodType,
    required this.diabetesPatient,
    required this.bloodPressurePatient,
    required this.heartPatient,
    required this.additionalInformation,
  });
  Map<String, dynamic> toJson() {
    return {
      'bloodType': bloodType,
      'diabetesPatient': diabetesPatient,
      'bloodPressurePatient': bloodPressurePatient,
      'heartPatient': heartPatient,
      'additionalInformation': additionalInformation,
      'userRegistered': true,
    };
  }
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
