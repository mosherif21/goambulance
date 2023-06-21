class UserInformation {
  String name;
  String email;
  String nationalId;
  DateTime birthDate;
  String gender;
  String phone;
  String sosMessage;
  bool criticalUser;

  UserInformation({
    required this.name,
    required this.email,
    required this.nationalId,
    required this.birthDate,
    required this.gender,
    required this.sosMessage,
    required this.criticalUser,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'nationalId': nationalId,
        'birthdate': birthDate,
        'gender': gender,
        'type': 'patient',
        'criticalUser': criticalUser,
        'sosMessage': sosMessage,
        'phone': phone,
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
  final String medicalAdditionalInfo;
  final String hypertensive;
  final String heartPatient;
  final List<DiseaseItem> diseasesList;
  List<String>? currentDiseasesDocIds;

  MedicalHistoryModel({
    required this.bloodType,
    required this.diabetic,
    required this.hypertensive,
    required this.heartPatient,
    required this.medicalAdditionalInfo,
    required this.diseasesList,
    this.currentDiseasesDocIds,
  });

  Map<String, dynamic> toJson() => {
        'bloodType': bloodType,
        'diabetic': diabetic,
        'hypertensive': hypertensive,
        'heartPatient': heartPatient,
        'medicalAdditionalInfo': medicalAdditionalInfo,
      };
}

class SavedAddressesModel {
  final String addressName;
  final List<AddressItem> addressesList;

  SavedAddressesModel({
    required this.addressName,
    required this.addressesList,
  });

  Map<String, dynamic> toJson() => {
        'addressName': addressName,
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

class AddressItem {
  late final String? addressId;
  final String locationName;
  final String streetName;
  final String apartmentNumber;
  final String floorNumber;
  final String areaName;
  final bool isPrimary;
  final String? additionalInfo;

  AddressItem({
    this.addressId,
    required this.locationName,
    required this.streetName,
    required this.apartmentNumber,
    required this.floorNumber,
    required this.areaName,
    required this.isPrimary,
    this.additionalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'streetName': streetName,
      'apartmentNumber': apartmentNumber,
      'floorNumber': floorNumber,
      'areaName': areaName,
      'isPrimary': isPrimary,
      'additionalInfo': additionalInfo,
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
