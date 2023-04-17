import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/enums.dart';

class MakingRequestController extends GetxController {
  static MakingRequestController get instance => Get.find();
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

  //Location settings
  static const int distanceFilter = 40;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: distanceFilter,
  );
  final LocationAccuracy accuracy = LocationAccuracy.high;
  //maps vars
  final polylineCoordinates = <LatLng>[].obs;
  late Rx<Marker> driverMarker = const Marker(
    markerId: MarkerId('driver location'),
  ).obs;
  late BitmapDescriptor ambulanceDriverIcon;
  late GoogleMapController googleMapController;

  //location permissions and services vars
  final RxBool serviceEnabled = false.obs;
  final RxBool servicePermissionEnabled = false.obs;
  bool locationServiceDialog = false;
  bool locationPermissionDialog = false;
  MapStatus mapStatus = MapStatus.noLocationService;
  late StreamSubscription<ServiceStatus> serviceStatusStream;
  late StreamSubscription<Position> positionStream;
  Position? _currentLocation;

// @override
  // void dispose() {
  //   super.dispose();
  // }
}
