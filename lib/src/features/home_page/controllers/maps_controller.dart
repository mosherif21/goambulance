/*
import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../constants/no_localization_strings.dart';

class MapsController extends GetxController {
  static MapsController get instance => Get.find();
  @override
  void onInit() {
    super.onInit();
    getCurrentLocation().then(
      (value) => {getPolyPoints()},
    );
  }

  Future<void> getLocationsPermission() async {}
  final Completer<GoogleMapController> _googleMapController = Completer();

  final LatLng _place2 = const LatLng(31.223958388803208, 29.93226379758089);
  final polylineCoordinates = <LatLng>[].obs;

  LocationData? currentLocation;

  Future<void> getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });
    location.onLocationChanged
        .listen((newLocation) => currentLocation = newLocation);
  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      googleMapsAPIKey,
      PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      PointLatLng(_place2.latitude, _place2.longitude),
    );
    if (polylineResult.points.isNotEmpty) {
      for (var point in polylineResult.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
  }
}
*/
