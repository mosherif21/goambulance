import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/directions.dart'
    as google_web_directions_service;

import '../constants/no_localization_strings.dart';
import '../features/requests/components/requests_history/models.dart';
import 'app_init.dart';
import 'general_functions.dart';

Future<String> getStaticMapImgURL({
  required String marker1IconUrl,
  required LatLng marker1LatLng,
  required String marker1TitleIconUrl,
  required String marker2IconUrl,
  required LatLng marker2LatLng,
  required String marker2TitleIconUrl,
  required int sizeWidth,
  required int sizeHeight,
}) async {
  List<PointLatLng> points = [];
  try {
    final route = await getRouteToLocation(
      fromLocation: marker1LatLng,
      toLocation: marker2LatLng,
    );
    if (route != null) {
      points = PolylinePoints().decodePolyline(route);
    }
  } catch (err) {
    if (kDebugMode) {
      AppInit.logger.e(err.toString());
    }
  }
  final latLngPoints =
      points.map((point) => LatLng(point.latitude, point.longitude)).toList();
  latLngPoints.insert(0, marker1LatLng);
  latLngPoints.insert(latLngPoints.length, marker2LatLng);

  late final LatLngBounds bounds = getLatLngBounds(latLngList: latLngPoints);

  double zoomLevel = calculateZoomLevel(bounds, 350, 200);

  double centerLatitude =
      (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
  double centerLongitude =
      (bounds.southwest.longitude + bounds.northeast.longitude) / 2;
  final center = LatLng(centerLatitude, centerLongitude);
  return buildStaticMapURL(
      location: center,
      zoom: zoomLevel.toInt() - 1,
      markers: [
        StaticMarkerModel(location: marker1LatLng, iconUrl: marker1IconUrl),
        StaticMarkerModel(location: marker2LatLng, iconUrl: marker2IconUrl),
        StaticMarkerModel(
            location: LatLng(
                marker1LatLng.latitude +
                    getMarkerTitleDisplacement(
                        zoomLevel: zoomLevel.toInt() - 1),
                marker1LatLng.longitude),
            iconUrl: marker1TitleIconUrl),
        StaticMarkerModel(
            location: LatLng(
                marker2LatLng.latitude +
                    getMarkerTitleDisplacement(
                        zoomLevel: zoomLevel.toInt() - 1),
                marker2LatLng.longitude),
            iconUrl: marker2TitleIconUrl),
      ],
      polyLines: latLngPoints,
      sizeWidth: sizeWidth,
      sizeHeight: sizeHeight);
}

double getMarkerTitleDisplacement({required int zoomLevel}) {
  switch (zoomLevel) {
    case 1:
      return 0.07;
    case 2:
      return 0.06;
    case 3:
      return 0.05;
    case 4:
      return 0.04;
    case 5:
      return 0.03;
    case 6:
      return 0.02;
    case 7:
      return 0.01;
    case 8:
      return 0.009;
    case 9:
      return 0.008;
    case 10:
      return 0.007;
    case 11:
      return 0.006;
    case 12:
      return 0.002;
    case 13:
      return 0.001;
    case 14:
      return 0.0009;
    case 15:
      return 0.0008;
    case 16:
      return 0.0007;
    case 17:
      return 0.0006;
    case 18:
      return 0.0005;
    case 19:
      return 0.0004;
    case 20:
      return 0.0003;
    case 21:
      return 0.0002;
    default:
      return 0.003;
  }
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
    if (kDebugMode) {
      AppInit.logger.e(err.toString());
    }
  }
  return null;
}

String buildStaticMapURL({
  required LatLng location,
  required int zoom,
  required List<StaticMarkerModel> markers,
  required List<LatLng> polyLines,
  required int sizeWidth,
  required int sizeHeight,
}) {
  const baseUrl = 'https://maps.googleapis.com/maps/api/staticmap?';

  final locationParam = 'center=${location.latitude},${location.longitude}';

  final zoomParam = 'zoom=$zoom';

  final markerParams = markers
      .map((marker) =>
          'markers=icon:${marker.iconUrl}|${marker.location.latitude},${marker.location.longitude}')
      .join('&');

  const mapIDParam = 'map_id=$mapStyleID';

  final polylineParam = polyLines.isNotEmpty
      ? 'path=color:0x000000ff|weight:3|${polyLines.map((polyline) => '${polyline.latitude},${polyline.longitude}').join('|')}'
      : '';

  final params = [
    locationParam,
    zoomParam,
    'size=${sizeWidth}x$sizeHeight',
    'style=visibility:on',
    markerParams,
    mapIDParam,
    polylineParam,
  ].join('&');

  final url =
      '$baseUrl$params&key=${AppInit.isWeb ? googleMapsStaticAPIWebKey : googleMapsStaticAPIAndroidKey}';
  return url;
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
