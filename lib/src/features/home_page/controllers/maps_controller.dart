import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../firebase_files/firebase_access.dart';
import '../../../common_widgets/single_button_dialog_alert.dart';
import '../../../constants/no_localization_strings.dart';

class MapsController extends GetxController {
  static MapsController get instance => Get.find();

  final polylineCoordinates = <LatLng>[].obs;
  final RxBool serviceEnabled = false.obs;
  final RxBool servicePermissionEnabled = false.obs;
  bool locationServiceDialog = false;
  bool locationPermissionDialog = false;
  late Marker driverMarker;
  late StreamSubscription<ServiceStatus> serviceStatusStream;
  late StreamSubscription<Position> positionStream;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 40,
  );
  late Position? _currentLocation;

  //final Completer<GoogleMapController> _googleMapController = Completer();

  LatLng currentLocationGetter() {
    return LatLng(_currentLocation!.latitude, _currentLocation!.longitude);
  }

  @override
  void onInit() {
    super.onInit();
    _getLocationServices();
    _getLocationPermission();
    serviceStatusStream = Geolocator.getServiceStatusStream().listen(
      (ServiceStatus status) {
        if (kDebugMode) print(status);
        if (status == ServiceStatus.disabled) {
          serviceEnabled.value = false;
          servicePermissionEnabled.value = false;
          positionStream.pause();
          if (kDebugMode) print('position listener paused');
          locationServiceDialog = true;
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
            buttonText: 'oK'.tr,
            onPressed: () {
              Get.back();
              locationServiceDialog = false;
            },
            context: Get.context!,
            dismissible: true,
          ).showSingleButtonAlertDialog();
        } else if (status == ServiceStatus.enabled) {
          serviceEnabled.value = true;
          servicePermissionEnabled.value = true;
          positionStream.resume();
          if (kDebugMode) print('position listener resumed');
          if (locationServiceDialog) Get.back();
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    serviceStatusStream.cancel();
  }

  void _getLocationServices() async {
    // Test if location services are enabled.
    serviceEnabled.value = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled.value) {
      if (kDebugMode) print('location disabled');
      locationServiceDialog = true;
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
        buttonText: 'oK'.tr,
        onPressed: () async {
          Get.back();
          locationServiceDialog = false;
          // await Geolocator.openLocationSettings()
          //     .then((value) => _getLocationPermission());
        },
        context: Get.context!,
        dismissible: true,
      ).showSingleButtonAlertDialog();
    }
  }

  void _getLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationPermissionDialog = true;
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
            locationPermissionDialog = false;
            _getLocationPermission();
          },
          context: Get.context!,
          dismissible: true,
        ).showSingleButtonAlertDialog();
        if (kDebugMode) print('location permission denied');
      } else {
        if (kDebugMode) print('location permission enabled');
        getCurrentLocation();
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      if (kDebugMode) print('location permission first enabled');
      getCurrentLocation();
    } else if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) print('location permission denied forever');
      locationPermissionDialog = true;
      SingleButtonDialogAlert(
        title: 'locationPermission'.tr,
        content: Text(
          'locationPermissionDeniedForever'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        buttonText: 'oK'.tr,
        onPressed: () async {
          Get.back();
          locationPermissionDialog = false;
          // await Geolocator.openLocationSettings()
          //     .then((value) => _getLocationPermission());
        },
        context: Get.context!,
        dismissible: true,
      ).showSingleButtonAlertDialog();
    }
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then(
      (locationPosition) {
        _currentLocation = locationPosition;
        servicePermissionEnabled.value = true;
        Get.put(FirebaseDataAccess());
      },
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        _currentLocation = position;
        servicePermissionEnabled.value = true;
        if (kDebugMode) {
          print(position == null
              ? 'current location is Unknown'
              : 'current location ${position.latitude.toString()}, ${position.longitude.toString()}');
        }
      },
    );
  }

  Future<void> getPolyPoints(LatLng driverLocation) async {
    PolylinePoints polylinePoints = PolylinePoints();
    final List<LatLng> polylineCoordinatesLocal = [];
    await polylinePoints
        .getRouteBetweenCoordinates(
      googleMapsAPIKey,
      PointLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      PointLatLng(driverLocation.latitude, driverLocation.longitude),
    )
        .then(
      (polylineResult) {
        if (polylineResult.points.isNotEmpty) {
          for (var point in polylineResult.points) {
            polylineCoordinatesLocal
                .add(LatLng(point.latitude, point.longitude));
          }
          if (kDebugMode) print('poly line points calculated');
          polylineCoordinates.addAll(polylineCoordinatesLocal);
        }
      },
    );
  }
}
