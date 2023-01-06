import 'dart:async';

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
  final mapsController = MapsController.instance;
  bool listenForDriverLocation = false;
  late StreamSubscription driverLocationStreamSubscription;
  String userType = '';

  @override
  void onInit() async {
    super.onInit();
    await getUserType();
  }

  Future<void> getUserType() async {
    fireStore.collection('users').doc('drivers/$userId').get().then((snapshot) {
      if (snapshot.exists) {
        userType = 'drivers';
      } else {
        userType = 'users';
        driverLocationChanged();
      }
    });
  }

  Future<void> updateUserLocation(Position position) async {
    await fireDatabase
        .ref('locations/$userType/$userId/latitude')
        .set(position.latitude);
    await fireDatabase
        .ref('locations/$userType/$userId/longitude')
        .set(position.longitude);
  }

  void driverLocationChanged() {
    driverLocationStreamSubscription = fireDatabase
        .ref('locations/drivers/f3MLM25HIGddzihhuAJUYMICQoS2')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        if (listenForDriverLocation) {
          final snapshots = event.snapshot;
          for (var snapshot in snapshots.children) {
            Map<dynamic, dynamic> locationDataMap =
                snapshot.value as Map<dynamic, dynamic>;
            mapsController.getPolyPoints(LatLng(
                locationDataMap['latitude'], locationDataMap['longitude']));
          }
        }
      }
    });
  }

  void logout() {
    driverLocationStreamSubscription.cancel();
  }
}
