import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/directions.dart'
    as google_web_directions_service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants/no_localization_strings.dart';
import '../../../general/app_init.dart';
import '../../../general/general_functions.dart';
import '../components/requests_history/components/request_details_page.dart';
import '../components/requests_history/models.dart';
import '../components/tracking_request/components/tracking_request_page.dart';

class RequestsHistoryController extends GetxController {
  static RequestsHistoryController get instance => Get.find();

  final requestLoaded = false.obs;
  final requestsList = <RequestHistoryModel>[].obs;
  late final String userId;
  late final DocumentReference firestoreUserRef;
  late final FirebaseFirestore _firestore;
  late final FirebasePatientDataAccess firebasePatientDataAccess;
  final requestsRefreshController = RefreshController(initialRefresh: false);
  @override
  void onReady() async {
    userId = AuthenticationRepository.instance.fireUser.value!.uid;
    _firestore = FirebaseFirestore.instance;
    firestoreUserRef = _firestore.collection('users').doc(userId);
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    getRequestsHistory();
    super.onReady();
  }

  void onRefresh() async {
    getRequestsHistory();
    requestsRefreshController.refreshToIdle();
    requestsRefreshController.resetNoData();
  }

  void getRequestsHistory() async {
    try {
      requestLoaded.value = false;
      if (Get.isRegistered<FirebasePatientDataAccess>()) {
        final trace =
            FirebasePerformance.instance.newTrace('load_recent_requests');
        await trace.start();
        requestsList.value =
            await firebasePatientDataAccess.getRecentRequests();
        await trace.stop();
      }
      if (kDebugMode) {
        AppInit.logger.i('loaded requests history, no: ${requestsList.length}');
      }
      requestLoaded.value = true;
      for (int index = 0; index < requestsList.length; index++) {
        if (requestsList[index].requestStatus == RequestStatus.pending ||
            requestsList[index].requestStatus == RequestStatus.accepted) {
          getStaticMapImgURL(
            marker1IconUrl: requestMarkerImageUrl,
            marker1LatLng: requestsList[index].requestLocation,
            marker1TitleIconUrl:
                isLangEnglish() ? requestEngImageUrl : requestArImageUrl,
            marker1TitleLatLng: LatLng(
                requestsList[index].requestLocation.latitude + 0.003,
                requestsList[index].requestLocation.longitude),
            marker2IconUrl: hospitalMarkerImageUrl,
            marker2LatLng: requestsList[index].hospitalLocation,
            marker2TitleIconUrl:
                isLangEnglish() ? hospitalEngImageUrl : hospitalArImageUrl,
            marker2TitleLatLng: LatLng(
                requestsList[index].hospitalLocation.latitude + 0.003,
                requestsList[index].hospitalLocation.longitude),
          ).then((mapImgUrl) => requestsList[index].mapUrl.value = mapImgUrl);
        } else if (requestsList[index].requestStatus ==
            RequestStatus.assigned) {
          firebasePatientDataAccess
              .getAmbulanceLocation(
                  ambulanceDriverId: requestsList[index].ambulanceDriverID!)
              .then(
            (ambulanceLocation) {
              getStaticMapImgURL(
                marker1IconUrl: requestMarkerImageUrl,
                marker1LatLng: requestsList[index].requestLocation,
                marker1TitleIconUrl:
                    isLangEnglish() ? requestEngImageUrl : requestArImageUrl,
                marker1TitleLatLng: LatLng(
                    requestsList[index].requestLocation.latitude + 0.003,
                    requestsList[index].requestLocation.longitude),
                marker2IconUrl: ambulanceLocation != null
                    ? ambulanceMarkerImageUrl
                    : hospitalMarkerImageUrl,
                marker2LatLng:
                    ambulanceLocation ?? requestsList[index].hospitalLocation,
                marker2TitleIconUrl: isLangEnglish()
                    ? ambulanceLocation != null
                        ? ambulanceEngImageUrl
                        : hospitalEngImageUrl
                    : ambulanceLocation != null
                        ? ambulanceArImageUrl
                        : hospitalArImageUrl,
                marker2TitleLatLng: ambulanceLocation != null
                    ? LatLng(ambulanceLocation.latitude + 0.003,
                        ambulanceLocation.longitude)
                    : LatLng(
                        requestsList[index].hospitalLocation.latitude + 0.003,
                        requestsList[index].hospitalLocation.longitude),
              ).then(
                  (mapImgUrl) => requestsList[index].mapUrl.value = mapImgUrl);
            },
          );
        } else if (requestsList[index].requestStatus == RequestStatus.ongoing) {
          firebasePatientDataAccess
              .getAmbulanceLocation(
                  ambulanceDriverId: requestsList[index].ambulanceDriverID!)
              .then(
            (ambulanceLocation) {
              getStaticMapImgURL(
                marker1IconUrl: ambulanceLocation != null
                    ? ambulanceMarkerImageUrl
                    : requestMarkerImageUrl,
                marker1LatLng:
                    ambulanceLocation ?? requestsList[index].requestLocation,
                marker1TitleIconUrl: isLangEnglish()
                    ? ambulanceLocation != null
                        ? ambulanceEngImageUrl
                        : requestEngImageUrl
                    : ambulanceLocation != null
                        ? ambulanceArImageUrl
                        : requestArImageUrl,
                marker1TitleLatLng: ambulanceLocation != null
                    ? LatLng(ambulanceLocation.latitude + 0.003,
                        ambulanceLocation.longitude)
                    : LatLng(
                        requestsList[index].requestLocation.latitude + 0.003,
                        requestsList[index].requestLocation.longitude),
                marker2IconUrl: hospitalMarkerImageUrl,
                marker2LatLng: requestsList[index].hospitalLocation,
                marker2TitleIconUrl:
                    isLangEnglish() ? hospitalEngImageUrl : hospitalArImageUrl,
                marker2TitleLatLng: LatLng(
                    requestsList[index].hospitalLocation.latitude + 0.003,
                    requestsList[index].hospitalLocation.longitude),
              ).then(
                  (mapImgUrl) => requestsList[index].mapUrl.value = mapImgUrl);
            },
          );
        }
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
    }
  }

  void onRequestSelected({required RequestHistoryModel requestModel}) async {
    if (kDebugMode) {
      AppInit.logger.i('known status: ${requestModel.requestStatus}');
    }
    if (requestModel.requestStatus == RequestStatus.completed ||
        requestModel.requestStatus == RequestStatus.canceled) {
      Get.to(() => RequestDetailsPage(requestModel: requestModel),
          transition: getPageTransition());
    } else {
      showLoadingScreen();
      final requestStatus = await firebasePatientDataAccess.getRequestStatus(
          requestId: requestModel.requestId,
          knownStatus: requestModel.requestStatus);
      hideLoadingScreen();
      if (kDebugMode) {
        AppInit.logger
            .i('after check status: ${requestStatus ?? 'failed to check'}');
      }
      if (requestStatus != null) {
        requestModel.requestStatus = requestStatus;
        if (requestStatus == RequestStatus.pending ||
            requestStatus == RequestStatus.accepted ||
            requestStatus == RequestStatus.assigned ||
            requestStatus == RequestStatus.ongoing) {
          Get.to(() => TrackingRequestPage(requestModel: requestModel),
              transition: getPageTransition());
        } else {
          Get.to(() => RequestDetailsPage(requestModel: requestModel),
              transition: getPageTransition());
        }
      }
    }
  }

  Future<String> getStaticMapImgURL({
    required String marker1IconUrl,
    required LatLng marker1LatLng,
    required String marker1TitleIconUrl,
    required LatLng marker1TitleLatLng,
    required String marker2IconUrl,
    required LatLng marker2LatLng,
    required String marker2TitleIconUrl,
    required LatLng marker2TitleLatLng,
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
        AppInit.logger.e(err.toString());
      }
    }
    final latLngPoints =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    latLngPoints.insert(0, marker1LatLng);
    latLngPoints.insert(latLngPoints.length, marker2LatLng);

    late final LatLngBounds bounds = getLatLngBounds(latLngList: latLngPoints);

    double zoomLevel = calculateZoomLevel(bounds, 300, 150);

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
        StaticMarkerModel(
            location: marker1TitleLatLng, iconUrl: marker1TitleIconUrl),
        StaticMarkerModel(
            location: marker2TitleLatLng, iconUrl: marker2TitleIconUrl),
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

  @override
  void onClose() {
    requestsRefreshController.dispose();
    super.onClose();
  }
}
