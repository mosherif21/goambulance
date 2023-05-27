import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/directions.dart'
    as google_web_directions_service;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants/no_localization_strings.dart';
import '../../../general/app_init.dart';
import '../../../general/general_functions.dart';
import '../components/requests_history/models.dart';

class RequestsHistoryController extends GetxController {
  static RequestsHistoryController get instance => Get.find();

  final requestLoaded = false.obs;
  final requestsList = <RequestHistoryModel>[].obs;
  late final String userId;
  late final DocumentReference firestoreUserRef;
  late final FirebaseFirestore _firestore;
  final requestsRefreshController = RefreshController(initialRefresh: false);
  @override
  void onReady() async {
    userId = AuthenticationRepository.instance.fireUser.value!.uid;
    _firestore = FirebaseFirestore.instance;
    firestoreUserRef = _firestore.collection('users').doc(userId);
    super.onReady();
  }

  void onRefresh() async {
    getRequestsHistory();
    requestsRefreshController.refreshToIdle();
    requestsRefreshController.resetNoData();
  }

  void getRequestsHistory() async {
    try {
      final trace =
          FirebasePerformance.instance.newTrace('load_recent_requests');
      await trace.start();

      requestLoaded.value = false;
      final List<RequestHistoryModel> readRequestsHistory = [];

      final pendingSnapshot =
          await firestoreUserRef.collection('pendingRequests').get();
      final assignedSnapshot =
          await firestoreUserRef.collection('assignedRequests').get();
      final completedSnapshot =
          await firestoreUserRef.collection('completedRequests').get();
      final canceledSnapshot =
          await firestoreUserRef.collection('canceledRequests').get();

      // Process pending requests
      for (DocumentSnapshot pendingDoc in pendingSnapshot.docs) {
        final pendingRequestDocument = await _firestore
            .collection('pendingRequests')
            .doc(pendingDoc.id)
            .get();
        if (pendingRequestDocument.exists) {
          final hospitalLocationPoint =
              pendingRequestDocument['hospitalLocation'] as GeoPoint;
          final requestLocationPoint =
              pendingRequestDocument['requestLocation'] as GeoPoint;
          final status = pendingRequestDocument['status'].toString();
          final timeStamp = pendingRequestDocument['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timeStamp);
          final requestLocation = LatLng(
              requestLocationPoint.latitude, requestLocationPoint.longitude);
          final hospitalLocation = LatLng(
              hospitalLocationPoint.latitude, hospitalLocationPoint.longitude);
          final mapImgUrl = await getStaticMapImgURL(
            marker1IconUrl: requestMarkerImageUrl,
            marker1LatLng: requestLocation,
            marker2IconUrl: hospitalMarkerImageUrl,
            marker2LatLng: hospitalLocation,
          );
          final requestModel = RequestHistoryModel(
            requestId: pendingDoc.id,
            timeStamp: timeStamp,
            hospitalLocation: hospitalLocation,
            requestLocation: requestLocation,
            userId: pendingRequestDocument['userId'].toString(),
            hospitalId: pendingRequestDocument['hospitalId'].toString(),
            hospitalName: pendingRequestDocument['hospitalName'].toString(),
            isUser: pendingRequestDocument['isUser'] as bool,
            patientCondition:
                pendingRequestDocument['patientCondition'].toString(),
            backupNumber: pendingRequestDocument['backupNumber'].toString(),
            requestStatus: status == 'pending'
                ? RequestStatus.requestPending
                : RequestStatus.requestAccepted,
            requestDateTime: requestDateTime,
            mapUrl: mapImgUrl,
          );
          readRequestsHistory.add(requestModel);
        }
      }

      // Process assigned requests
      for (DocumentSnapshot assignedDoc in assignedSnapshot.docs) {
        final assignedRequestDocument = await _firestore
            .collection('assignedRequests')
            .doc(assignedDoc.id)
            .get();
        if (assignedRequestDocument.exists) {
          final hospitalLocationPoint =
              assignedRequestDocument['hospitalLocation'] as GeoPoint;
          final requestLocationPoint =
              assignedRequestDocument['requestLocation'] as GeoPoint;
          final timeStamp = assignedRequestDocument['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timeStamp);
          final requestLocation = LatLng(
              requestLocationPoint.latitude, requestLocationPoint.longitude);
          final hospitalLocation = LatLng(
              hospitalLocationPoint.latitude, hospitalLocationPoint.longitude);
          final mapImgUrl = await getStaticMapImgURL(
            marker1IconUrl: requestMarkerImageUrl,
            marker1LatLng: requestLocation,
            marker2IconUrl: hospitalMarkerImageUrl,
            marker2LatLng: hospitalLocation,
          );
          final requestModel = RequestHistoryModel(
            requestId: assignedDoc.id,
            timeStamp: timeStamp,
            hospitalLocation: hospitalLocation,
            requestLocation: requestLocation,
            userId: assignedRequestDocument['userId'].toString(),
            hospitalId: assignedRequestDocument['hospitalId'].toString(),
            hospitalName: assignedRequestDocument['hospitalName'].toString(),
            isUser: assignedRequestDocument['isUser'] as bool,
            patientCondition:
                assignedRequestDocument['patientCondition'].toString(),
            backupNumber: assignedRequestDocument['backupNumber'].toString(),
            requestStatus: RequestStatus.requestAssigned,
            requestDateTime: requestDateTime,
            mapUrl: mapImgUrl,
          );
          readRequestsHistory.add(requestModel);
        }
      }

      // Process completed requests
      for (DocumentSnapshot completedDoc in completedSnapshot.docs) {
        final completedRequestDocument = await _firestore
            .collection('completedRequests')
            .doc(completedDoc.id)
            .get();
        if (completedRequestDocument.exists) {
          final hospitalLocationPoint =
              completedRequestDocument['hospitalLocation'] as GeoPoint;
          final requestLocationPoint =
              completedRequestDocument['requestLocation'] as GeoPoint;
          final timeStamp = completedRequestDocument['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timeStamp);
          final requestLocation = LatLng(
              requestLocationPoint.latitude, requestLocationPoint.longitude);
          final hospitalLocation = LatLng(
              hospitalLocationPoint.latitude, hospitalLocationPoint.longitude);
          final requestModel = RequestHistoryModel(
            requestId: completedDoc.id,
            timeStamp: timeStamp,
            hospitalLocation: hospitalLocation,
            requestLocation: requestLocation,
            userId: completedRequestDocument['userId'].toString(),
            hospitalId: completedRequestDocument['hospitalId'].toString(),
            hospitalName: completedRequestDocument['hospitalName'].toString(),
            isUser: completedRequestDocument['isUser'] as bool,
            patientCondition:
                completedRequestDocument['patientCondition'].toString(),
            backupNumber: completedRequestDocument['backupNumber'].toString(),
            requestStatus: RequestStatus.requestCompleted,
            requestDateTime: requestDateTime,
          );
          readRequestsHistory.add(requestModel);
        }
      }

      // Process canceled requests
      for (DocumentSnapshot canceledDoc in canceledSnapshot.docs) {
        final canceledRequestDocument = await _firestore
            .collection('canceledRequests')
            .doc(canceledDoc.id)
            .get();
        if (canceledRequestDocument.exists) {
          final hospitalLocationPoint =
              canceledRequestDocument['hospitalLocation'] as GeoPoint;
          final requestLocationPoint =
              canceledRequestDocument['requestLocation'] as GeoPoint;
          final timeStamp = canceledRequestDocument['timestamp'] as Timestamp;
          final requestDateTime = formatDateTime(timeStamp);
          final requestLocation = LatLng(
              requestLocationPoint.latitude, requestLocationPoint.longitude);
          final hospitalLocation = LatLng(
              hospitalLocationPoint.latitude, hospitalLocationPoint.longitude);
          final requestModel = RequestHistoryModel(
            requestId: canceledDoc.id,
            timeStamp: timeStamp,
            hospitalLocation: hospitalLocation,
            requestLocation: requestLocation,
            userId: canceledRequestDocument['userId'].toString(),
            hospitalId: canceledRequestDocument['hospitalId'].toString(),
            hospitalName: canceledRequestDocument['hospitalName'].toString(),
            isUser: canceledRequestDocument['isUser'] as bool,
            patientCondition:
                canceledRequestDocument['patientCondition'].toString(),
            backupNumber: canceledRequestDocument['backupNumber'].toString(),
            requestStatus: RequestStatus.requestCanceled,
            requestDateTime: requestDateTime,
          );
          readRequestsHistory.add(requestModel);
        }
      }
      // Sort the list by timestamp
      readRequestsHistory.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      requestsList.value = readRequestsHistory;
      if (kDebugMode) print('loaded requests history');
      if (kDebugMode) print(readRequestsHistory.length);
      requestLoaded.value = true;
      await trace.stop();
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }

  Future<String> getStaticMapImgURL({
    required String marker1IconUrl,
    required LatLng marker1LatLng,
    required String marker2IconUrl,
    required LatLng marker2LatLng,
  }) async {
    List<PointLatLng> points = [];
    try {
      final route = await getRouteToLocation(
        fromLocation: marker1LatLng,
        toLocation: marker2LatLng,
      );
      points = PolylinePoints().decodePolyline(route!);
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
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
      zoom: zoomLevel.toInt(),
      markers: [
        StaticMarkerModel(location: marker1LatLng, iconUrl: marker1IconUrl),
        StaticMarkerModel(location: marker2LatLng, iconUrl: marker2IconUrl),
      ],
      polyLines: latLngPoints,
    );
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

  String buildStaticMapURL({
    required LatLng location,
    required int zoom,
    required List<StaticMarkerModel> markers,
    required List<LatLng> polyLines,
  }) {
    const baseUrl = 'https://maps.googleapis.com/maps/api/staticmap?';

    final locationParam = 'center=${location.latitude},${location.longitude}';

    final zoomParam = 'zoom=$zoom';

    final markerParams = markers
        .map((marker) =>
            'markers=icon:${marker.iconUrl}|${marker.location.latitude},${marker.location.longitude}')
        .join('&');

    const mapIDParam = 'map_id=$mapID';

    final polylineParam = polyLines.isNotEmpty
        ? 'path=color:0x000000ff|weight:3|${polyLines.map((polyline) => '${polyline.latitude},${polyline.longitude}').join('|')}'
        : '';

    final params = [
      locationParam,
      zoomParam,
      'size=350x200',
      markerParams,
      mapIDParam,
      polylineParam,
    ].join('&');

    final url = '$baseUrl$params&key=$googleMapsStaticAPIKey';
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

  String formatDateTime(Timestamp timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    DateFormat formatter = DateFormat("MMM d y hh:mm a");
    return formatter.format(dateTime);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
