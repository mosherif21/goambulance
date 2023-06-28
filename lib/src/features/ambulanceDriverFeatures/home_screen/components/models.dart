import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalModel {
  final String hospitalId;
  final String name;
  final String avgAmbulancePrice;
  final String geohash;
  final String hospitalNumber;
  final String address;
  final LatLng location;

  HospitalModel({
    required this.hospitalId,
    required this.name,
    required this.avgAmbulancePrice,
    required this.geohash,
    required this.location,
    required this.hospitalNumber,
    required this.address,
  });
}

class UserInfoRequestModel {
  final String email;
  final String name;
  final bool criticalUser;
  final String gender;
  final String backupNumber;
  final String phoneNumber;
  final String profilePicUrl;
  final int age;

  UserInfoRequestModel({
    required this.name,
    required this.criticalUser,
    required this.email,
    required this.gender,
    required this.profilePicUrl,
    required this.backupNumber,
    required this.phoneNumber,
    required this.age,
  });
}
