import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/directions.dart'
    as google_web_directions_service;

import '../../../constants/assets_strings.dart';
import '../../../constants/enums.dart';
import '../../../constants/no_localization_strings.dart';
import '../../../general/app_init.dart';
import '../../../general/general_functions.dart';
import '../components/requests_history/components/ongoing_request_item.dart';
import '../components/requests_history/models.dart';

class RequestsHistoryController extends GetxController {
  static RequestsHistoryController get instance => Get.find();
  late final BitmapDescriptor requestLocationMarkerIcon;
  late final BitmapDescriptor hospitalMarkerIcon;
  late Widget ongoingTest;
  final snapshotLoaded = false.obs;
  late String mapStyle;

  @override
  void onReady() async {
    await _loadMarkersIcon();
    await rootBundle.loadString(kMapStyle).then((style) => mapStyle = style);
    super.onReady();
  }

  double calculateZoomLevel(
      LatLngBounds bounds, double mapWidth, double mapHeight) {
    const double globe = 256; // Width of the Google Maps tile in pixels
    const double zoomMax = 21; // Maximum zoom level

    double latFraction =
        (bounds.northeast.latitude - bounds.southwest.latitude).abs();
    double lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;

    double latZoom = log(mapHeight * 360 / (latFraction * globe)) / log(2);
    double lngZoom = log(mapWidth * 360 / (lngDiff * globe)) / log(2);
    double zoom = min(latZoom, lngZoom);

    return (zoom > zoomMax) ? zoomMax : zoom;
  }

  String buildStaticMapURL({
    required LatLng location,
    required int zoom,
    required List<StaticMarkerModel> markers,
    required List<LatLng> polylines,
  }) {
    const baseUrl = 'https://maps.googleapis.com/maps/api/staticmap?';

    // Location parameter
    final locationParam = 'center=${location.latitude},${location.longitude}';

    // Zoom parameter
    final zoomParam = 'zoom=$zoom';

    // Markers parameter
    final markerParams = markers
        .map((marker) =>
            'markers=|${marker.location.latitude},${marker.location.longitude}')
        .join('&');

    // Map ID parameter
    const mapIDParam = 'map_id=$mapID';

    // Polyline parameter
    final polylineParam = polylines.isNotEmpty
        ? 'path=color:0x000000ff|weight:3|${polylines.map((polyline) => '${polyline.latitude},${polyline.longitude}').join('|')}'
        : '';

    // Combine all parameters
    final params = [
      locationParam,
      zoomParam,
      'size=350x200',
      markerParams,
      mapIDParam,
      polylineParam,
    ].join('&');

    // Construct the complete URL
    final url = '$baseUrl$params&key=$googleMapsStaticAPIKey';
    if (kDebugMode) {
      print(url);
    }
    return url;
  }

  void testStaticImage({
    required String marker1Id,
    required BitmapDescriptor marker1Icon,
    required LatLng marker1LatLng,
    required String marker2Id,
    required BitmapDescriptor marker2Icon,
    required LatLng marker2LatLng,
  }) async {
    try {
      final route = await getRouteToLocation(
        fromLocation: marker1LatLng,
        toLocation: marker2LatLng,
      );
      final points = PolylinePoints().decodePolyline(route!);
      final latLngPoints = points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      latLngPoints.insert(0, marker1LatLng);
      latLngPoints.insert(latLngPoints.length, marker2LatLng);

      late final LatLngBounds bounds =
          getLatLngBounds(latLngList: latLngPoints);

      double zoomLevel = calculateZoomLevel(bounds, 350, 200);

      double centerLatitude =
          (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
      double centerLongitude =
          (bounds.southwest.longitude + bounds.northeast.longitude) / 2;
      final center = LatLng(centerLatitude, centerLongitude);
      final imageUrl = buildStaticMapURL(
        location: center,
        zoom: zoomLevel.toInt(),
        markers: [
          StaticMarkerModel(location: marker1LatLng, iconUrl: requestImageUrl),
          StaticMarkerModel(location: marker2LatLng, iconUrl: hospitalImageUrl),
        ],
        polylines: latLngPoints,
      );
      snapshotLoaded.value = true;
      ongoingTest = OngoingRequestItem(
        onPressed: () {},
        hospitalName: 'Royal Hospital',
        dateTime: 'Apr 17 2023 1:54 PM',
        status: RequestStatus.requestAccepted,
        mapUrl: imageUrl,
      );
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
    return null;
  }

  Future<String?> getRouteToLocation({
    required LatLng fromLocation,
    required LatLng toLocation,
  }) async {
    try {
      final directions = google_web_directions_service.GoogleMapsDirections(
        baseUrl: AppInit.isWeb ? "https://cors-anywhere.herokuapp.com/" : null,
        apiKey: googleMapsAPIKeyWeb,
      );
      final result = await directions.directionsWithLocation(
        google_web_directions_service.Location(
            lat: fromLocation.latitude, lng: fromLocation.longitude),
        google_web_directions_service.Location(
            lat: toLocation.latitude, lng: toLocation.longitude),
        travelMode: google_web_directions_service.TravelMode.driving,
        language: isLangEnglish() ? 'en' : 'ar',
      );
      final route = result.routes.first;
      final polyline = route.overviewPolyline.points;

      return polyline;
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
    return null;
  }

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

  Future<void> _loadMarkersIcon() async {
    await _getBytesFromAsset(kRequestLocationMarkerImg, 120).then((iconBytes) {
      requestLocationMarkerIcon = BitmapDescriptor.fromBytes(iconBytes);
    });

    await _getBytesFromAsset(kHospitalMarkerImg, 160).then((iconBytes) {
      hospitalMarkerIcon = BitmapDescriptor.fromBytes(iconBytes);
    });
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
