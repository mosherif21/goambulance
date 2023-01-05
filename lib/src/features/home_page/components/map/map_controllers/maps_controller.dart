import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/text_dismissible_dialogue.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../firebase_files/firebase_access.dart';
import '../../../../../constants/no_localization_strings.dart';

enum MapStatus {
  loadingMapData,
  noLocationPermission,
  noLocationService,
  mapDataLoaded,
}

class MapsController extends GetxController {
  static MapsController get instance => Get.find();
  static const int distanceFilter = 40;
  final polylineCoordinates = <LatLng>[].obs;
  final RxBool serviceEnabled = false.obs;
  final RxBool servicePermissionEnabled = false.obs;
  bool locationServiceDialog = false;
  bool locationPermissionDialog = false;
  MapStatus mapStatus = MapStatus.loadingMapData;
  final LocationAccuracy accuracy = LocationAccuracy.high;
  late Marker driverMarker;
  late BitmapDescriptor ambulanceDriverIcon;
  // late Marker currentLocationMarker;
  // late BitmapDescriptor currentLocationIcon;

  late StreamSubscription<ServiceStatus> serviceStatusStream;
  late StreamSubscription<Position> positionStream;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: distanceFilter,
  );
  Position? _currentLocation;

  //final Completer<GoogleMapController> _googleMapController = Completer();

  LatLng currentLocationGetter() {
    return LatLng(_currentLocation!.latitude, _currentLocation!.longitude);
  }

  @override
  void onInit() async {
    super.onInit();
    await loadMarkersIcon();
    _getLocationServices();
    _getLocationPermission();
    if (!AppInit.isWeb) {
      _setupLocationServiceListener();
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (!AppInit.isWeb) serviceStatusStream.cancel();
  }

  void _setupLocationServiceListener() {
    serviceStatusStream = Geolocator.getServiceStatusStream().listen(
      (ServiceStatus status) {
        if (kDebugMode) print(status);
        if (status == ServiceStatus.disabled) {
          serviceEnabled.value = false;
          servicePermissionEnabled.value = false;
          if (_currentLocation != null) positionStream.pause();
          mapStatus = MapStatus.noLocationService;
          if (kDebugMode) print('position listener paused');
          locationServiceDialog = true;
          TextSingleButtonDialogue(
            title: 'locationService'.tr,
            body: 'enableLocationService'.tr,
            onPressed: () {
              Get.back();
              locationServiceDialog = false;
            },
            buttonText: 'oK'.tr,
          ).showTextSingleButtonDialogue();
        } else if (status == ServiceStatus.enabled) {
          mapStatus = MapStatus.loadingMapData;
          serviceEnabled.value = true;
          if (_currentLocation != null) {
            positionStream.resume();
            servicePermissionEnabled.value = true;
          } else {
            getCurrentLocation();
          }
          if (kDebugMode) print('position listener resumed');
          if (locationServiceDialog) Get.back();
        }
      },
    );
  }

  void _getLocationServices() async {
    // Test if location services are enabled.
    serviceEnabled.value = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled.value) {
      if (kDebugMode) print('location disabled');
      locationServiceDialog = true;
      TextSingleButtonDialogue(
        title: 'locationService'.tr,
        body: 'enableLocationService'.tr,
        onPressed: () async {
          Get.back();
          locationServiceDialog = false;
          // await Geolocator.openLocationSettings()
          //     .then((value) => _getLocationPermission());
        },
        buttonText: 'oK'.tr,
      ).showTextSingleButtonDialogue();
    }
  }

  void _getLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationPermissionDialog = true;
        TextSingleButtonDialogue(
          title: 'locationPermission'.tr,
          body: 'enableLocationPermission'.tr,
          onPressed: () {
            Get.back();
            locationPermissionDialog = false;
            _getLocationPermission();
          },
          buttonText: 'oK'.tr,
        ).showTextSingleButtonDialogue();

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
      TextSingleButtonDialogue(
        title: 'locationPermission'.tr,
        body: 'locationPermissionDeniedForever'.tr,
        onPressed: () async {
          Get.back();
          locationPermissionDialog = false;
          // await Geolocator.openLocationSettings()
          //     .then((value) => _getLocationPermission());
        },
        buttonText: 'oK'.tr,
      ).showTextSingleButtonDialogue();
    }
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: accuracy).then(
      (locationPosition) {
        _currentLocation = locationPosition;
        servicePermissionEnabled.value = true;
        mapStatus = MapStatus.mapDataLoaded;
        Get.put(FirebaseDataAccess());
      },
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        _currentLocation = position;
        servicePermissionEnabled.value = true;
        mapStatus = MapStatus.mapDataLoaded;
        if (kDebugMode) {
          print(position == null
              ? 'current location is Unknown'
              : 'current location ${position.latitude.toString()}, ${position.longitude.toString()}');
        }
      },
    );
  }

  Future<void> getPolyPoints(LatLng driverLocation) async {
    driverMarker = Marker(
      markerId: const MarkerId('driver location'),
      icon: ambulanceDriverIcon,
      position: driverLocation,
      anchor: const Offset(0.5, 0.5),
    );
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      final List<LatLng> polylineCoordinatesLocal = [];
      await polylinePoints
          .getRouteBetweenCoordinates(
        googleMapsAPIKey,
        PointLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
        PointLatLng(driverLocation.latitude, driverLocation.longitude),
        travelMode: TravelMode.driving,
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
    } catch (e) {
      if (kDebugMode) {
        e.printError();
      }
    }
  }

  Future<void> loadMarkersIcon() async {
    await getBytesFromAsset(
            AppInit.isWeb ? kAmbulanceMarkerImg : kAmbulanceMarkerImgUnscaled,
            130)
        .then((iconBytes) {
      ambulanceDriverIcon = BitmapDescriptor.fromBytes(iconBytes);
    });
    // await getBytesFromAsset(kAmbulanceMarkerImg, AppInit.isWeb ? 50 : 150)
    //     .then((iconBytes) {
    //   ambulanceDriverIcon = BitmapDescriptor.fromBytes(iconBytes);
    // });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
