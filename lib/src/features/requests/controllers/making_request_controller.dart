import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/no_localization_strings.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '../../../constants/assets_strings.dart';
import '../../../constants/colors.dart';

class MakingRequestController extends GetxController {
  static MakingRequestController get instance => Get.find();

  //Location settings
  final locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 40,
  );
  final accuracy = LocationAccuracy.high;

  //maps vars
  final RxSet<Polyline> mapPolyLines = <Polyline>{}.obs;
  final RxSet<Marker> mapMarkers = <Marker>{}.obs;
  final Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();
  late final GoogleMapController googleMapController;
  bool googleMapControllerInit = false;

  //location permissions and services vars
  final locationAvailable = false.obs;
  final mapLoading = false.obs;
  late Position currentLocation;
  late LatLng searchedLocation;
  late StreamSubscription<ServiceStatus>? serviceStatusStream;
  late StreamSubscription<Position>? currentPositionStream;
  bool locationServiceDialog = false;
  bool positionStreamInitialized = false;
  final locationPermissionGranted = false.obs;
  final locationServiceEnabled = false.obs;
  final mapEnabled = false.obs;
  bool allowedLocation = false;
  final searchedText = 'searchPlace'.tr.obs;
  late String mapStyle;
  late CameraPosition currentCameraPosition;
  final RxDouble mapPinMargin = 85.0.obs;

  @override
  void onReady() async {
    await locationInit();
    setupLocationServiceListener();
    await rootBundle.loadString(kMapStyle).then((style) => mapStyle = style);
    initMapController();
    super.onReady();
  }

  Future<void> locationInit() async {
    showLoadingScreen();
    await handleLocationService().then((locationService) {
      locationServiceEnabled.value = locationService;
      setupLocationPermission();
    });
    hideLoadingScreen();
  }

  Future<void> setupLocationPermission() async {
    await handleLocationPermission(showSnackBar: true).then(
      (permissionGranted) {
        locationPermissionGranted.value = permissionGranted;
        if (permissionGranted && locationServiceEnabled.value) {
          getCurrentLocation();
        }
      },
    );
  }

  void initMapController() {
    mapControllerCompleter.future.then((controller) {
      googleMapController = controller;
      controller.setMapStyle(mapStyle);
      googleMapControllerInit = true;
    });
  }

  Future<void> onRequestPress() async {
    if (allowedLocation) {
      showSimpleSnackBar(text: 'noice');
    } else {
      showSimpleSnackBar(text: 'locationNotAllowed'.tr);
    }
  }

  Future<void> googlePlacesSearch({required BuildContext context}) async {
    try {
      final predictions = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleMapsAPIKey,
        hint: 'searchPlace'.tr,
        onError: (response) {
          if (kDebugMode) print(response.errorMessage ?? '');
        },
        region: 'EG',
        cursorColor: Colors.black,
        mode: Mode.overlay,
        language: isLangEnglish() ? 'en' : 'ar',
        backArrowIcon: const Icon(Icons.arrow_back_ios_sharp),
      );
      if (predictions != null && predictions.description != null) {
        if (kDebugMode) print(predictions.description);
        searchedLocation =
            await getLocationFromAddress(address: predictions.description!);
        enableMap();
        animateToLocation(locationLatLng: searchedLocation);
      }
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }

  CameraPosition getInitialCameraPosition() {
    currentCameraPosition = CameraPosition(
      target:
          locationAvailable.value ? currentLocationGetter() : searchedLocation,
      zoom: 15.5,
    );
    return currentCameraPosition;
  }

  Future<String> getAddressFromLocation({required LatLng latLng}) async {
    final addresses = await Geocoder2.getDataFromCoordinates(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      googleMapApiKey: googleMapsAPIKey,
      language: isLangEnglish() ? 'en' : 'ar',
    );
    checkAllowedLocation(countryCode: addresses.countryCode);
    return addresses.address;
  }

  Future<LatLng> getLocationFromAddress({required String address}) async {
    final location = await Geocoder2.getDataFromAddress(
      address: address,
      googleMapApiKey: googleMapsAPIKey,
      language: isLangEnglish() ? 'en' : 'ar',
    );
    checkAllowedLocation(countryCode: location.countryCode);
    return LatLng(location.latitude, location.longitude);
  }

  void checkAllowedLocation({required String countryCode}) {
    if (countryCode.compareTo('EG') == 0) {
      allowedLocation = true;
    } else {
      allowedLocation = false;
    }
  }

  void setupLocationServiceListener() async {
    try {
      serviceStatusStream = Geolocator.getServiceStatusStream().listen(
        (ServiceStatus status) {
          if (kDebugMode) print(status);

          if (status == ServiceStatus.enabled) {
            locationServiceEnabled.value = true;

            if (locationPermissionGranted.value) {
              if (positionStreamInitialized) {
                currentPositionStream?.resume();
                if (kDebugMode) print('position listener resumed');
              } else {
                getCurrentLocation();
              }
            }

            if (locationServiceDialog) Get.back();
          } else if (status == ServiceStatus.disabled) {
            if (positionStreamInitialized) {
              currentPositionStream?.pause();
              if (kDebugMode) print('position listener paused');
            }
            locationServiceEnabled.value = false;
            locationServiceDialog = true;
            Dialogs.materialDialog(
              title: 'locationService'.tr,
              msg: 'enableLocationService'.tr,
              color: Colors.white,
              context: Get.context!,
              actions: [
                IconsButton(
                  onPressed: () {
                    Get.back();
                    locationServiceDialog = false;
                  },
                  text: 'ok'.tr,
                  iconData: Icons.check_circle_outline,
                  color: kDefaultColor,
                  textStyle: const TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ],
            );
          }
        },
      );
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }

  void enableMap() {
    mapEnabled.value = true;
  }

  void animateToCurrentLocation() {
    if (locationAvailable.value) {
      animateCamera(locationLatLng: currentLocationGetter());
    }
  }

  void animateToLocation({required LatLng locationLatLng}) {
    if (mapEnabled.value) {
      if (googleMapControllerInit) {
        animateCamera(locationLatLng: locationLatLng);
      }
    }
  }

  void onCameraIdle() async {
    if (mapEnabled.value) {
      if (googleMapControllerInit) {
        try {
          searchedText.value = 'loading'.tr;
          if (kDebugMode) print(currentCameraPosition.target);
          final address = await getAddressFromLocation(
              latLng: currentCameraPosition.target);
          searchedText.value = allowedLocation ? address : 'notAllowed'.tr;
        } catch (err) {
          if (kDebugMode) print(err.toString());
        }
      }
    }
  }

  void animateCamera({required LatLng locationLatLng}) {
    mapPinMargin.value = 150;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: locationLatLng,
        zoom: 15.5,
      ),
    ));
  }

  void getCurrentLocation() async {
    try {
      mapLoading.value = true;
      await Geolocator.getCurrentPosition(desiredAccuracy: accuracy).then(
        (locationPosition) {
          currentLocation = locationPosition;
          locationAvailable.value = true;
          enableMap();
          if (kDebugMode) {
            print(
                'current location ${locationPosition.latitude.toString()}, ${locationPosition.longitude.toString()}');
          }
        },
      );

      positionStreamInitialized = true;
      currentPositionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (Position? position) {
          if (position != null) {
            currentLocation = position;
            locationAvailable.value = true;
            enableMap();
          }
          if (kDebugMode) {
            print(position == null
                ? 'current location is Unknown'
                : 'current location ${position.latitude.toString()}, ${position.longitude.toString()}');
          }
        },
      );
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }

  LatLng currentLocationGetter() {
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  @override
  void onClose() async {
    await serviceStatusStream?.cancel();
    if (positionStreamInitialized) await currentPositionStream?.cancel();
    if (googleMapControllerInit) googleMapController.dispose();

    super.onClose();
  }

// Polyline(
//   polylineId: const PolylineId('router_driver'),
//   color: const Color(0xFF28AADC),
//   // ignore: invalid_use_of_protected_member
//   points: mapsController.polylineCoordinates.value,
//   width: 4,
//   startCap: Cap.roundCap,
//   endCap: Cap.roundCap,
//   jointType: JointType.round,
//   geodesic: true,
// ),
//       {
//   mapsController.driverMarker.value,
//   if (AppInit.isWeb)
//   Marker(
//   markerId: const MarkerId('current_location'),
//   position: mapsController.currentLocationGetter()),
// }

// Future<void> getRoute(LatLng driverLocation) async {
//   driverMarker.value = Marker(
//     markerId: const MarkerId('driver_location'),
//     icon: ambulanceDriverIcon,
//     position: driverLocation,
//     anchor: const Offset(0.5, 0.5),
//   );
//   List<LatLng> polylineCoordinatesLocal = [];
//   if (!AppInit.isWeb) {
//     PolylineResult polylineResult = await PolylinePoints()
//         .getRouteBetweenCoordinates(
//         AppInit.isWeb ? googleMapsAPIKeyWeb : googleMapsAPIKey,
//         PointLatLng(
//             _currentLocation!.latitude, _currentLocation!.longitude),
//         PointLatLng(driverLocation.latitude, driverLocation.longitude),
//         travelMode: TravelMode.driving,
//         optimizeWaypoints: true);
//     if (polylineResult.points.isNotEmpty) {
//       if (polylineResult.points.isNotEmpty) {
//         for (var point in polylineResult.points) {
//           polylineCoordinatesLocal
//               .add(LatLng(point.latitude, point.longitude));
//           polylineCoordinates.assignAll(polylineCoordinatesLocal);
//         }
//       }
//     }
//   } else {
//     polylineCoordinatesLocal
//         .add(LatLng(_currentLocation!.latitude, _currentLocation!.longitude));
//     polylineCoordinatesLocal
//         .add(LatLng(driverLocation.latitude, driverLocation.longitude));
//     polylineCoordinates.assignAll(polylineCoordinatesLocal);
//   }
// }
//
// Future<void> _loadMarkersIcon() async {
//   await _getBytesFromAsset(
//       AppInit.isWeb ? kAmbulanceMarkerImg : kAmbulanceMarkerImgUnscaled,
//       130)
//       .then((iconBytes) {
//     ambulanceDriverIcon = BitmapDescriptor.fromBytes(iconBytes);
//   });
// }
//
// Future<Uint8List> _getBytesFromAsset(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//       targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//       .buffer
//       .asUint8List();
// }
}
