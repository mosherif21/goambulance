import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/single_button_dialog_alert.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../constants/no_localization_strings.dart';

class MapsController extends GetxController {
  static MapsController get instance => Get.find();

  final Location _location = Location();
  final polylineCoordinates = <LatLng>[].obs;
  final RxBool serviceEnabled = false.obs;
  final RxBool servicePermissionEnabled = false.obs;
  late Marker driverMarker;
  late LocationData? _currentLocation;
  late PermissionStatus _locationPermission;

  //final Completer<GoogleMapController> _googleMapController = Completer();

  // @override
  // void onInit() {
  //   super.onInit();
  //
  // }

  LatLng currentLocationGetter() => LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      );

  Future<void> getLocationsPermission() async {
    serviceEnabled.value = await _location.serviceEnabled();
    if (!serviceEnabled.value) {
      serviceEnabled.value = await _location.requestService();
      if (!serviceEnabled.value) {
        SingleButtonDialogAlert(
          title: 'locationService'.tr,
          content: Text(
            'enableLocationService'.tr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          buttonText: 'OK'.tr,
          onPressed: () {
            Get.back();
            getLocationsPermission();
          },
          context: Get.context!,
          dismissible: true,
        ).showSingleButtonAlertDialog();
      }
    } else {
      _locationPermission = await _location.hasPermission();
      if (_locationPermission == PermissionStatus.denied) {
        _locationPermission = await _location.requestPermission();
        if (_locationPermission != PermissionStatus.granted) {
          servicePermissionEnabled.value = false;
          SingleButtonDialogAlert(
            title: 'locationPermission'.tr,
            content: Text(
              'enableLocationPermission'.tr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            buttonText: 'oK'.tr,
            onPressed: () {
              Get.back();
              getLocationsPermission();
            },
            context: Get.context!,
            dismissible: true,
          ).showSingleButtonAlertDialog();
        } else {
          servicePermissionEnabled.value = true;
          getCurrentLocation();
        }
      }
    }
  }

  Future<void> getCurrentLocation() async {
    _location.getLocation().then((location) => _currentLocation = location);
    _location.onLocationChanged.listen(
      (newLocation) => _currentLocation = newLocation,
    );
  }

  Future<void> getPolyPoints(LatLng driverLocation) async {
    PolylinePoints polylinePoints = PolylinePoints();
    final List<LatLng> polylineCoordinatesLocal = [];
    await polylinePoints
        .getRouteBetweenCoordinates(
      googleMapsAPIKey,
      PointLatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      PointLatLng(driverLocation.latitude, driverLocation.longitude),
    )
        .then(
      (polylineResult) {
        if (polylineResult.points.isNotEmpty) {
          for (var point in polylineResult.points) {
            polylineCoordinatesLocal
                .add(LatLng(point.latitude, point.longitude));
          }
          polylineCoordinates.addAll(polylineCoordinatesLocal);
        }
      },
    );
  }
}
