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
