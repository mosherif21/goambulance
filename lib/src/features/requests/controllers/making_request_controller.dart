import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

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
  late GoogleMapController mapController;
  late BitmapDescriptor ambulanceDriverIcon;

  //location permissions and services vars
  final locationAvailable = false.obs;
  final mapLoading = false.obs;

  late Position? currentLocation;

  late StreamSubscription<ServiceStatus>? serviceStatusStream;
  late StreamSubscription<Position>? currentPositionStream;

  bool locationServiceDialog = false;
  bool positionStreamInitialized = false;
  RxBool locationPermissionGranted = false.obs;
  @override
  void onInit() async {
    setupLocationServiceListener();
    super.onInit();
  }

  void setupLocationServiceListener() async {
    try {
      locationPermissionGranted.value =
          await handleLocationPermission(showSnackBar: true);
      mapLoading.value = await handleLocationService();
      if (mapLoading.value) getCurrentLocation();
      serviceStatusStream = Geolocator.getServiceStatusStream().listen(
        (ServiceStatus status) {
          if (kDebugMode) print(status);
          if (status == ServiceStatus.disabled) {
            if (positionStreamInitialized) currentPositionStream?.pause();
            if (kDebugMode) print('position listener paused');
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
          } else if (status == ServiceStatus.enabled) {
            if (locationServiceDialog) Get.back();
            mapLoading.value = true;
            if (positionStreamInitialized) {
              currentPositionStream?.resume();
            } else {
              getCurrentLocation();
            }
            if (kDebugMode) print('position listener resumed');
          }
        },
      );
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }

  void getCurrentLocation() async {
    try {
      await Geolocator.getCurrentPosition(desiredAccuracy: accuracy).then(
        (locationPosition) {
          currentLocation = locationPosition;
          locationAvailable.value = true;
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
    return LatLng(currentLocation!.latitude, currentLocation!.longitude);
  }

  @override
  void onClose() async {
    await serviceStatusStream?.cancel();
    if (positionStreamInitialized) await currentPositionStream?.cancel();
    if (locationAvailable.value) mapController.dispose();
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
