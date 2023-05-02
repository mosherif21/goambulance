class UserInformation {
  String name;
  String email;
  String nationalId;
  DateTime birthDate;
  String gender;
  String bloodType;
  String diabetic;
  String additionalInformation;
  String phoneNumber;
  String hypertensive;
  String heartPatient;
  String sosMessage;
  bool criticalUser;
  UserInformation({
    required this.name,
    required this.email,
    required this.nationalId,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.diabetic,
    required this.hypertensive,
    required this.heartPatient,
    required this.additionalInformation,
    required this.phoneNumber,
    required this.sosMessage,
    required this.criticalUser,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'nationalId': nationalId,
        'phoneNo': phoneNumber,
        'birthdate': birthDate,
        'gender': gender,
        'bloodType': bloodType,
        'diabetic': diabetic,
        'hypertensive': hypertensive,
        'heartPatient': heartPatient,
        'additionalInformation': additionalInformation,
        'type': 'patient',
        'criticalUser': criticalUser,
        'sosMessage': sosMessage,
      };
}

class AccountDetailsModel {
  String name;
  String email;
  String nationalId;
  DateTime birthDate;
  String gender;
  AccountDetailsModel({
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

class MedicalHistoryModel {
  final String bloodType;
  final String diabetic;
  final String additionalInformation;
  final String hypertensive;
  final String heartPatient;
  final List<DiseaseItem> diseasesList;
  MedicalHistoryModel({
    required this.bloodType,
    required this.diabetic,
    required this.hypertensive,
    required this.heartPatient,
    required this.additionalInformation,
    required this.diseasesList,
  });
  Map<String, dynamic> toJson() => {
        'bloodType': bloodType,
        'diabetic': diabetic,
        'hypertensive': hypertensive,
        'heartPatient': heartPatient,
        'additionalInformation': additionalInformation,
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
