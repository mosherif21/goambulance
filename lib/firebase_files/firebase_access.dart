import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_page/components/map/map_controllers/maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseDataAccess extends GetxController {
  static FirebaseDataAccess get instance => Get.find();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final fireStore = FirebaseFirestore.instance;
  final fireDatabase = FirebaseDatabase.instance;
  bool listenForDriverLocation = false;

  @override
  void onInit() {
    super.onInit();
  }

  final LatLng _driverLocation =
      const LatLng(31.223958388803208, 29.93226379758089);

  Future<void> updateUserLocation(Position position) async {
    await fireStore.collection('location').doc('/$userId').set({
      'latitude': position.latitude,
      'longitude': position.longitude,
    }, SetOptions(merge: true));
  }

  void driverLocationChanged() {
    if (listenForDriverLocation) {
      final mapsController = MapsController.instance;
      mapsController.getPolyPoints(
        _driverLocation,
      );
    }
  }
}
