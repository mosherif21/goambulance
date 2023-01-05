import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../firebase_files/firebase_access.dart';
import '../../../../../common_widgets/single_button_dialog_alert.dart';

class MapsController extends GetxController {
  static MapsController get instance => Get.find();
  static const int distanceFilter = 40;
  final polylineCoordinates = <LatLng>[].obs;
  final RxBool serviceEnabled = false.obs;
  final RxBool servicePermissionEnabled = false.obs;
  bool locationServiceDialog = false;
  bool locationPermissionDialog = false;

  late Marker driverMarker;
  BitmapDescriptor ambulanceDriverIcon = BitmapDescriptor.defaultMarker;

  late StreamSubscription<ServiceStatus> serviceStatusStream;
  late StreamSubscription<Position> positionStream;
  late final LocationSettings locationSettings;
  late Position? _currentLocation;

  //final Completer<GoogleMapController> _googleMapController = Completer();

  LatLng currentLocationGetter() {
    return LatLng(_currentLocation!.latitude, _currentLocation!.longitude);
  }

  @override
  void onInit() async {
    super.onInit();
    await loadAmbulanceMarkerIcon();
    _getLocationServices();
    _getLocationPermission();
    if (!AppInit.isWeb) {
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
  }

  @override
  void onClose() {
    super.onClose();
    if (!AppInit.isWeb) serviceStatusStream.cancel();
  }

  Future<void> loadAmbulanceMarkerIcon() async {
    await getBytesFromAsset(kAmbulanceMarkerImg, 150).then((iconBytes) {
      ambulanceDriverIcon = BitmapDescriptor.fromBytes(iconBytes);
    });
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
    var accuracy = AppInit.isWeb
        ? LocationAccuracy.high
        : await Geolocator.getLocationAccuracy();
    if (accuracy == LocationAccuracyStatus.reduced) {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.reduced,
        distanceFilter: distanceFilter,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      );
    }
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> getPolyPoints(LatLng driverLocation) async {
    PolylinePoints polylinePoints = PolylinePoints();
    driverMarker = Marker(
      markerId: const MarkerId('driver location'),
      icon: ambulanceDriverIcon,
      position: driverLocation,
      anchor: const Offset(0.5, 0.5),
    );
    // final List<LatLng> polylineCoordinatesLocal = [];
    // await polylinePoints
    //     .getRouteBetweenCoordinates(
    //   googleMapsAPIKey,
    //   PointLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
    //   PointLatLng(driverLocation.latitude, driverLocation.longitude),
    // )
    //     .then(
    //   (polylineResult) {
    //     if (polylineResult.points.isNotEmpty) {
    //       for (var point in polylineResult.points) {
    //         polylineCoordinatesLocal
    //             .add(LatLng(point.latitude, point.longitude));
    //       }
    //       if (kDebugMode) print('poly line points calculated');
    //       polylineCoordinates.addAll(polylineCoordinatesLocal);
    //     }
    //   },
    // );
  }
}
