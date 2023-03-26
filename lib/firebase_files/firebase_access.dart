import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

enum UserType { driver, user }

class FirebaseDataAccess extends GetxController {
  static FirebaseDataAccess get instance => Get.find();

  final userId = AuthenticationRepository.instance.fireUser.value?.uid;
  final fireStore = FirebaseFirestore.instance;
  final fireDatabase = FirebaseDatabase.instance;
  UserType userType = UserType.user;
  bool userInitialize = false;

  //StreamSubscription? driverLocationStreamSubscription;
  // bool listenForDriverLocation = false;

  Future<void> getUserType() async {
    if (!userInitialize) {
      userInitialize = true;
      await fireDatabase.ref('users/drivers/$userId').get().then((snapshot) {
        if (snapshot.exists) {
          userType = UserType.driver;
        } else {
          userType = UserType.user;
        }
        if (kDebugMode) print('user type is $userType');
      });
    }
  }

  //
  // Future<void> updateUserLocation(Position position) async {
  //   final userTypeRef = userType == UserType.driver ? 'drivers' : 'users';
  //   final locationRef = 'locations/$userTypeRef/$userId';
  //   await fireDatabase.ref('$locationRef/latitude').set(position.latitude);
  //   await fireDatabase.ref('$locationRef/longitude').set(position.longitude);
  // }
  //
  // void driverLocationChanged() {
  //   driverLocationStreamSubscription = fireDatabase
  //       .ref('locations/drivers/f3MLM25HIGddzihhuAJUYMICQoS2')
  //       .onValue
  //       .listen((event) {
  //     if (event.snapshot.exists) {
  //       if (listenForDriverLocation) {
  //         final snapshot = event.snapshot;
  //         Map<dynamic, dynamic> locationDataMap =
  //             snapshot.value as Map<dynamic, dynamic>;
  //         final latitude =
  //             double.tryParse(locationDataMap['latitude'].toString());
  //         final longitude =
  //             double.tryParse(locationDataMap['longitude'].toString());
  //         if (latitude != null && longitude != null) {
  //           MapsController.instance.getRoute(LatLng(latitude, longitude));
  //         }
  //       }
  //     }
  //   });
  // }

  Future<void> logoutFirebase() async {
    if (userType == UserType.user) {
      await fireDatabase.ref('locations/users/$userId').set(null);
    } else {
      await fireDatabase.ref('locations/drivers/$userId').set(null);
    }
  }
}
