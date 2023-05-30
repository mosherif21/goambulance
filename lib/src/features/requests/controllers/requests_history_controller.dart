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
      final trace =
          FirebasePerformance.instance.newTrace('load_recent_requests');
      await trace.start();
      final gotRequests = await firebasePatientDataAccess.getRecentRequests();
      await trace.stop();
      if (gotRequests != null) {
        requestsList.value = gotRequests;
        if (kDebugMode) {
          AppInit.logger
              .i('loaded requests history, no: ${requestsList.length}');
        }
      } else {
        showSnackBar(
            text: 'errorOccurred'.tr, snackBarType: SnackBarType.error);
        if (kDebugMode) {
          AppInit.logger.e('Failed to get requests');
        }
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
            marker2IconUrl: hospitalMarkerImageUrl,
            marker2LatLng: requestsList[index].hospitalLocation,
            marker2TitleIconUrl:
                isLangEnglish() ? hospitalEngImageUrl : hospitalArImageUrl,
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
                marker2IconUrl: hospitalMarkerImageUrl,
                marker2LatLng: requestsList[index].hospitalLocation,
                marker2TitleIconUrl:
                    isLangEnglish() ? hospitalEngImageUrl : hospitalArImageUrl,
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
    final initialKnownStatus = requestModel.requestStatus;
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
        if (initialKnownStatus != requestStatus) {
          getRequestsHistory();
        }
      } else {
        showSnackBar(
            text: 'errorOccurred'.tr, snackBarType: SnackBarType.error);
      }
    }
  }

  Future<String> getStaticMapImgURL({
    required String marker1IconUrl,
    required LatLng marker1LatLng,
    required String marker1TitleIconUrl,
    required String marker2IconUrl,
    required LatLng marker2LatLng,
    required String marker2TitleIconUrl,
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
    );
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
