// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:screenshot/screenshot.dart';
// // ignore: depend_on_referenced_packages
// import 'package:google_maps_webservice/directions.dart'
// as google_web_directions_service;
// import '../../../constants/no_localization_strings.dart';
// import '../../../general/app_init.dart';
// import '../../../general/general_functions.dart';

class RequestsHistoryController extends GetxController {
  static RequestsHistoryController get instance => Get.find();
  final screenshotController = ScreenshotController();
  @override
  void onReady() async {
    super.onReady();
  }

  // void getMapImage({
  //   required String marker1Id,
  //   required BitmapDescriptor marker1Icon,
  //   required LatLng marker1LatLng,
  //   required String marker2Id,
  //   required BitmapDescriptor marker2Icon,
  //   required LatLng marker2LatLng,
  // }) async {
  //   try {
  //     Completer<GoogleMapController> mapControllerCompleter =
  //     Completer<GoogleMapController>();
  //     ScreenshotController screenshotController = ScreenshotController();
  //
  //     // Create the markers and polyLines
  //     Set<Marker> markers = {
  //       Marker(
  //         markerId: MarkerId(marker1Id),
  //         position: marker1LatLng,
  //         icon: marker1Icon,
  //       ),
  //       Marker(
  //         markerId:  MarkerId(marker2Id),
  //         position: marker2LatLng,
  //         icon: marker2Icon,
  //         anchor: const Offset(0.5, 0.5),
  //       ),
  //     };
  //
  //     Set<Polyline> polyLines = {
  //        Polyline(polylineId: PolylineId('route'), points: [
  //         LatLng(37.7749, -122.4194),
  //         LatLng(37.7899, -122.4154),
  //         LatLng(37.7752, -122.4156),
  //       ]),
  //     };
  //
  //     // Create a new GoogleMap widget without rendering it on the screen
  //     GoogleMap googleMap = GoogleMap(
  //       initialCameraPosition:
  //       CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 12),
  //       markers: markers,
  //       polylines: polyLines,
  //       onMapCreated: (GoogleMapController controller) {
  //         mapControllerCompleter.complete(controller);
  //       },
  //     );
  //
  //     // Create a widget tree with the GoogleMap and Screenshot widgets
  //     Widget app = MaterialApp(
  //       home: Scaffold(
  //         body: Column(
  //           children: [
  //             Expanded(
  //               child: Screenshot(
  //                 controller: screenshotController,
  //                 child: googleMap,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //
  //     // Create a widget binding and attach the app
  //     WidgetsFlutterBinding.ensureInitialized();
  //     WidgetsBinding.instance.attachRootWidget(app);
  //
  //     // Wait for the map controller to be initialized
  //     GoogleMapController mapController = await mapControllerCompleter.future;
  //
  //     // Adjust the camera position
  //     LatLngBounds.Builder boundsBuilder = LatLngBounds.Builder();
  //     for (Marker marker in markers) {
  //       boundsBuilder.include(marker.position);
  //     }
  //     for (Polyline polyline in polyLines) {
  //       for (LatLng point in polyline.points) {
  //         boundsBuilder.include(point);
  //       }
  //     }
  //     LatLngBounds bounds = boundsBuilder.build();
  //     CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
  //     mapController.animateCamera(cameraUpdate);
  //
  //     // Wait for the camera to finish adjusting
  //     Completer<void> cameraAdjustCompleter = Completer<void>();
  //     CameraPosition? previousPosition = null;
  //     Timer.periodic(const Duration(milliseconds: 100), (cameraTimer) async{
  //       LatLngBounds currentPosition = await mapController.getVisibleRegion();
  //       if () {
  //         cameraTimer.cancel();
  //         cameraAdjustCompleter.complete();
  //       }
  //       previousPosition = currentPosition;
  //     });
  //     await cameraAdjustCompleter.future;
  //
  //     // Capture the screenshot
  //     Uint8List? screenshotBytes =
  //     await screenshotController.capture();
  //
  //     // Clean up resources
  //     mapController.dispose();
  //
  //   } catch (err) {
  //     if (kDebugMode) {
  //       print(err.toString());
  //     }
  //   }
  // }
  // Future<void> getRouteToLocation(
  //     {required LatLng fromLocation,
  //       required LatLng toLocation,
  //       required String routeId}) async {
  //   try {
  //     final directions = google_web_directions_service.GoogleMapsDirections(
  //       baseUrl: AppInit.isWeb ? "https://cors-anywhere.herokuapp.com/" : null,
  //       apiKey: googleMapsAPIKeyWeb,
  //     );
  //     final result=await  directions.directionsWithLocation(
  //       google_web_directions_service.Location(
  //           lat: fromLocation.latitude, lng: fromLocation.longitude),
  //       google_web_directions_service.Location(
  //           lat: toLocation.latitude, lng: toLocation.longitude),
  //       travelMode: google_web_directions_service.TravelMode.driving,
  //       language: isLangEnglish() ? 'en' : 'ar',
  //     );
  //     final route = result.routes.first;
  //     final polyline = route.overviewPolyline.points;
  //     final polylinePoints = PolylinePoints();
  //     final points = polylinePoints.decodePolyline(polyline);
  //     final latLngPoints = points
  //         .map((point) => LatLng(point.latitude, point.longitude))
  //         .toList();
  //     latLngPoints.insert(0, fromLocation);
  //     latLngPoints.insert(latLngPoints.length, toLocation);
  //     Polyline(
  //       polylineId: PolylineId(routeId),
  //       color: Colors.black,
  //       points: latLngPoints,
  //       width: 5,
  //       startCap: Cap.roundCap,
  //       endCap: Cap.roundCap,
  //       jointType: JointType.round,
  //       geodesic: true,
  //     );
  //     animateToLatLngBounds(
  //         latLngBounds:
  //         getLatLngBounds(latLngList: routeToHospital.value!.points));
  //     mapPolyLines.add(routeToHospital.value!);
  //   } catch (err) {
  //     if (kDebugMode) print(err.toString());
  //   }
  // }

  LatLngBounds getLatLngBounds({required List<LatLng> latLngList}) {
    double southWestLat = 90.0;
    double southWestLng = 180.0;
    double northEastLat = -90.0;
    double northEastLng = -180.0;

    for (LatLng point in latLngList) {
      if (point.latitude < southWestLat) {
        southWestLat = point.latitude;
      }
      if (point.longitude < southWestLng) {
        southWestLng = point.longitude;
      }
      if (point.latitude > northEastLat) {
        northEastLat = point.latitude;
      }
      if (point.longitude > northEastLng) {
        northEastLng = point.longitude;
      }
    }
    LatLng southWest = LatLng(southWestLat, southWestLng);
    LatLng northEast = LatLng(northEastLat, northEastLng);
    return LatLngBounds(southwest: southWest, northeast: northEast);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
