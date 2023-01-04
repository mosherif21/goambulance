import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_access.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../constants/no_localization_strings.dart';

class MapsController extends GetxController {
  static MapsController get instance => Get.find();

  final Location _location = Location();
  final polylineCoordinates = <LatLng>[].obs;
  late StreamSubscription currentLocationListener;
  //final Completer<GoogleMapController> _googleMapController = Completer();

  Future<void> getLocationsPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> getCurrentLocation() async {
    LocationData? currentLocation;
    _location.getLocation().then((location) => currentLocation = location);
    currentLocationListener = _location.onLocationChanged.listen(
      (newLocation) {
        currentLocation = newLocation;
        getPolyPoints(
          currentLocation!,
          FirebaseDataAccess.instance.getDriverLocation(),
        );
      },
    );
  }

  Future<void> getPolyPoints(
      LocationData currentLocation, LatLng driverLocation) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      googleMapsAPIKey,
      PointLatLng(currentLocation.latitude!, currentLocation.longitude!),
      PointLatLng(driverLocation.latitude, driverLocation.longitude),
    );
    if (polylineResult.points.isNotEmpty) {
      for (var point in polylineResult.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
  }
}
