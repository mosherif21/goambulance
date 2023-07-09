// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';
import 'package:goambulance/src/constants/no_localization_strings.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/employee_map/navigation_select.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/models.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webapi/directions.dart'
    as google_web_directions_service;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../constants/enums.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../components/employee_map/employee_medical_information.dart';
import '../components/employee_map/employee_user_information.dart';

class EmployeeHomeScreenController extends GetxController {
  static EmployeeHomeScreenController get instance => Get.find();

  //location permissions and services vars
  final locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 40,
  );
  final accuracy = LocationAccuracy.high;
  final locationAvailable = false.obs;
  late Position currentLocation;
  StreamSubscription<ServiceStatus>? serviceStatusStream;
  StreamSubscription<Position>? currentPositionStream;
  bool positionStreamInitialized = false;
  final locationPermissionGranted = false.obs;
  final locationServiceEnabled = false.obs;

  //maps vars
  RxSet<Polyline> mapPolyLines = <Polyline>{}.obs;
  final mapMarkersAnimated = <MarkerId, Marker>{}.obs;
  final mapMarkers = <Marker>{}.obs;
  final kAmbulanceMarkerId = const MarkerId('ambulanceMarker');
  int routeToDestinationTime = 0;
  Marker? requestLocationMarker;
  Marker? ambulanceMarker;
  Marker? hospitalMarker;

  late final BitmapDescriptor requestLocationMarkerIcon;
  late final BitmapDescriptor hospitalMarkerIcon;
  late final BitmapDescriptor ambulanceMarkerIcon;
  final mapControllerCompleter = Completer<GoogleMapController>();
  late final GoogleMapController googleMapController;
  bool googleMapControllerInit = false;
  final hospitalLoaded = false.obs;
  final hospitalDataAvailable = false.obs;
  late String mapStyle;
  late LatLng initialCameraLatLng;
  late LatLng hospitalLatLng;
  bool cameraMoved = false;
  final requestPanelController = PanelController();

  //making request
  late LatLng currentCameraLatLng;
  final hasAssignedRequest = false.obs;
  final assignedRequestLoaded = false.obs;
  final hospitalsLoaded = false.obs;
  final requestStatus = RequestStatus.non.obs;
  late final FirebaseAmbulanceEmployeeDataAccess firebaseEmployeeDataAccess;

  CancelableOperation<google_web_directions_service.DirectionsResponse?>?
      getRouteOperation;
  late final FirebaseFirestore _firestore;
  late final String userId;
  late final HospitalModel hospitalInfo;

  //geoQuery vars
  final geoFire = GeoFlutterFire();

  final notificationsCount = 0.obs;
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      notificationCountStreamSubscription;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      assignedRequestStreamSubscription;
  EmployeeRequestDataModel? assignedRequestData;
  String? currentAssignedRequestId;
  UserInfoRequestModel? userRequestInfo;
  bool loggingOut = false;
  @override
  void onReady() async {
    _firestore = FirebaseFirestore.instance;
    userId = AuthenticationRepository.instance.fireUser.value!.uid;
    firebaseEmployeeDataAccess = FirebaseAmbulanceEmployeeDataAccess.instance;
    loadHospitalInfo();
    initMapController();
    listenForNotificationCount();

    handleLocationService().then((locationService) {
      locationServiceEnabled.value = locationService;
      handleLocationPermission().then((locationPermission) {
        locationPermissionGranted.value = locationPermission;
        if (locationService && locationPermission) {
          getCurrentLocation();
        }
      });
    });
    if (!AppInit.isWeb) {
      setupLocationServiceListener();
    }
    super.onReady();
  }

  void listenForNotificationCount() {
    try {
      notificationCountStreamSubscription = _firestore
          .collection('notifications')
          .doc(userId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final notificationData = snapshot.data();
          if (notificationData != null) {
            notificationsCount.value = notificationData['unseenCount'] as int;
          }
        } else {
          notificationsCount.value = 0;
        }
      });
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

  void listenForAssignedRequests() {
    try {
      assignedRequestStreamSubscription = _firestore
          .collection('users')
          .doc(userId)
          .collection('assignedRequests')
          .snapshots()
          .listen((snapshots) {
        if (snapshots.docs.isNotEmpty) {
          final snapshot = snapshots.docs.first;
          if (snapshot.exists) {
            if (assignedRequestData == null) {
              final requestId = snapshot.id;
              currentAssignedRequestId = requestId;
              onAssignedChanges();
            }
          }
        } else {
          if (hasAssignedRequest.value) {
            if (assignedRequestLoaded.value) {
              onNotAssignedChanges();
            }
            requestPanelController.close();
            hasAssignedRequest.value = false;
          }
        }
      });
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

  void onAssignedChanges() async {
    requestPanelController.open();
    hasAssignedRequest.value = true;
    Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
      animateCamera(
          locationLatLng: locationAvailable.value
              ? currentLocationGetter()
              : hospitalLatLng);
    });
    textToSpeech(text: 'newAssignedRequest'.tr);
    loadAssignedRequest();
  }

  void onNotAssignedChanges() async {
    clearRoutes();
    clearMarkers();
    assignedRequestLoaded.value = false;
    requestStatus.value = RequestStatus.non;
    assignedRequestData = null;
    currentAssignedRequestId = null;
    Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
      animateCamera(
          locationLatLng: locationAvailable.value
              ? currentLocationGetter()
              : hospitalLatLng);
    });
  }

  void onAssignedLoadedChanges() async {
    requestStatus.value = RequestStatus.assigned;
    if (assignedRequestData != null) {
      if (assignedRequestData!.requestStatus == RequestStatus.assigned) {
        requestLocationMarker = Marker(
          markerId: const MarkerId('requestMarker'),
          position: assignedRequestData!.requestLocation,
          icon: requestLocationMarkerIcon,
          consumeTapEvents: true,
        );
        mapMarkers.add(requestLocationMarker!);
      }
    }
    updateRouteAndMap();
  }

  void onConfirmPickup() async {
    if (assignedRequestLoaded.value && assignedRequestData != null) {
      assignedRequestData!.requestStatus = RequestStatus.ongoing;
      showLoadingScreen();
      final trace =
          FirebasePerformance.instance.newTrace('confirm_request_pickup');
      await trace.start();
      final functionStatus = await firebaseEmployeeDataAccess.confirmPickup(
          requestId: assignedRequestData!.requestId);
      await trace.stop();
      hideLoadingScreen();
      if (functionStatus == FunctionStatus.success) {
        requestStatus.value = RequestStatus.ongoing;
        clearMarkers();
        clearRoutes();
        updateRouteAndMap();
        if (!assignedRequestData!.notifiedOngoing) {
          assignedRequestData!.notifiedOngoing = true;
          final functionStatus =
              await firebaseEmployeeDataAccess.sendNotification(
            userId: assignedRequestData!.userId,
            hospitalName: assignedRequestData!.hospitalName,
            notificationType: EmployeeNotificationType.requestOngoing,
            requestId: assignedRequestData!.requestId,
          );
          if (functionStatus == FunctionStatus.success) {
            assignedRequestData!.notifiedOngoing = true;
          } else {
            assignedRequestData!.notifiedOngoing = false;
          }
        }
      } else {
        assignedRequestData!.requestStatus = RequestStatus.assigned;
        showSnackBar(text: 'unknownError'.tr, snackBarType: SnackBarType.error);
      }
    }
  }

  void onConfirmDropOff() async {
    if (assignedRequestLoaded.value && assignedRequestData != null) {
      if (assignedRequestData!.requestStatus == RequestStatus.ongoing) {
        final trace = FirebasePerformance.instance.newTrace('complete_request');
        await trace.start();
        final functionStatus = await firebaseEmployeeDataAccess.completeRequest(
            requestInfo: assignedRequestData!);
        await trace.stop();
        if (functionStatus == FunctionStatus.success) {
          clearRoutes();
          clearMarkers();
          animateCamera(
              locationLatLng: locationAvailable.value
                  ? currentLocationGetter()
                  : initialCameraLatLng);
        } else {
          showSnackBar(
              text: 'unknownError'.tr, snackBarType: SnackBarType.error);
        }
      }
    }
  }

  void updateRouteAndMap() {
    if (assignedRequestData != null) {
      if (assignedRequestData!.requestStatus == RequestStatus.assigned) {
        if (locationAvailable.value) {
          ambulanceMarker = Marker(
            markerId: kAmbulanceMarkerId,
            position: locationAvailable.value
                ? currentLocationGetter()
                : initialCameraLatLng,
            icon: ambulanceMarkerIcon,
            anchor: const Offset(0.5, 0.5),
            consumeTapEvents: true,
          );
          mapMarkersAnimated[kAmbulanceMarkerId] = ambulanceMarker!;
        }
        getRouteToLocation(
          fromLocation: locationAvailable.value
              ? currentLocationGetter()
              : initialCameraLatLng,
          toLocation: assignedRequestData!.requestLocation,
          routeId: 'routeToHospital',
        ).then((routePolyLine) {
          if (routePolyLine != null) {
            mapPolyLines.value = {routePolyLine};
            Future.delayed(const Duration(seconds: 1)).whenComplete(() =>
                animateToLatLngBounds(
                    latLngBounds:
                        getLatLngBounds(latLngList: routePolyLine.points)));
          }
        });
      } else if (assignedRequestData!.requestStatus == RequestStatus.ongoing) {
        if (locationAvailable.value) {
          ambulanceMarker = Marker(
            markerId: kAmbulanceMarkerId,
            position: locationAvailable.value
                ? currentLocationGetter()
                : assignedRequestData!.requestLocation,
            icon: ambulanceMarkerIcon,
            anchor: const Offset(0.5, 0.5),
            consumeTapEvents: true,
          );
          mapMarkersAnimated[kAmbulanceMarkerId] = ambulanceMarker!;
        }
        getRouteToLocation(
          fromLocation: locationAvailable.value
              ? currentLocationGetter()
              : assignedRequestData!.requestLocation,
          toLocation: assignedRequestData!.hospitalLocation,
          routeId: 'routeToHospital',
        ).then((routePolyLine) {
          if (routePolyLine != null) {
            mapPolyLines.value = {routePolyLine};
            Future.delayed(const Duration(seconds: 1)).whenComplete(() =>
                animateToLatLngBounds(
                    latLngBounds:
                        getLatLngBounds(latLngList: routePolyLine.points)));
          }
        });
      }
    }
  }

  void clearRoutes() async {
    getRouteOperation?.cancel();
    mapPolyLines.clear();
  }

  void clearMarkers() async {
    if (requestLocationMarker != null) {
      if (mapMarkers.contains(requestLocationMarker)) {
        mapMarkers.remove(requestLocationMarker);
      }
    }
  }

  Future<void> cancelListeners() async {
    loggingOut = true;
    if (!AppInit.isWeb) {
      await serviceStatusStream?.cancel();
    }
    if (positionStreamInitialized) await currentPositionStream?.cancel();
    await notificationCountStreamSubscription?.cancel();
    await assignedRequestStreamSubscription?.cancel();
    loggingOut = false;
  }

  void loadHospitalInfo() async {
    hospitalLoaded.value = false;
    final hospitalInfoGet = await firebaseEmployeeDataAccess.getHospitalInfo();
    hospitalLoaded.value = true;
    if (hospitalInfoGet != null) {
      hospitalLatLng = hospitalInfoGet.location;
      hospitalInfo = hospitalInfoGet;
      hospitalDataAvailable.value = true;
    } else {
      hospitalDataAvailable.value = false;
    }
  }

  void initMapController() {
    mapControllerCompleter.future.then((controller) async {
      googleMapController = controller;
      await rootBundle.loadString(kMapStyle).then((style) => mapStyle = style);
      controller.setMapStyle(mapStyle);
      googleMapControllerInit = true;
      await _loadMarkersIcon();
      hospitalMarker = Marker(
        markerId: const MarkerId('requestMarker'),
        position: hospitalLatLng,
        icon: hospitalMarkerIcon,
        consumeTapEvents: true,
      );
      mapMarkers.add(hospitalMarker!);
      ambulanceMarker = Marker(
        markerId: kAmbulanceMarkerId,
        position: locationAvailable.value
            ? currentLocationGetter()
            : initialCameraLatLng,
        icon: ambulanceMarkerIcon,
        anchor: const Offset(0.5, 0.5),
        consumeTapEvents: true,
      );
      mapMarkersAnimated[kAmbulanceMarkerId] = ambulanceMarker!;
      if (AppInit.isWeb) {
        animateCamera(locationLatLng: initialCameraLatLng);
      }
      listenForAssignedRequests();
    });
  }

  void onStartNavigationPressed() {
    if (assignedRequestData != null) {
      RegularBottomSheet.showRegularBottomSheet(
        NavigationSelect(
          headerText: 'wayToNavigate'.trParams({
            'destinationName':
                assignedRequestData!.requestStatus == RequestStatus.assigned
                    ? 'requestLocation'.tr
                    : assignedRequestData!.hospitalName,
          }),
          onInAppNavigationPress: () {
            RegularBottomSheet.hideBottomSheet();
            startNavigation(mapBoxNavigation: true);
          },
          onGoogleMapsNavigationPress: () {
            RegularBottomSheet.hideBottomSheet();
            startNavigation(mapBoxNavigation: false);
          },
        ),
      );
    }
  }

  void startNavigation({required bool mapBoxNavigation}) async {
    if (locationPermissionGranted.value && locationServiceEnabled.value) {
      showLoadingScreen();
      currentLocation =
          await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);

      if (mapBoxNavigation) {
        await startMapboxNavigation();
      } else {
        await openGoogleMapsNavigation();
      }
      hideLoadingScreen();
    } else {
      if (await handleLocationPermission() && await handleLocationService()) {
        showLoadingScreen();
        currentLocation =
            await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);

        if (mapBoxNavigation) {
          await startMapboxNavigation();
        } else {
          await openGoogleMapsNavigation();
        }
        hideLoadingScreen();
      }
    }
  }

  Future<void> openGoogleMapsNavigation() async {
    String mapUrl = '';
    if (AppInit.isIos) {
      // mapUrl =
      // 'https://maps.apple.com/?daddr=$latitude,$longitude';
      // URL for IOS
    } else {
      if (assignedRequestData != null) {
        if (assignedRequestData!.requestStatus == RequestStatus.assigned) {
          mapUrl =
              'https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${assignedRequestData!.requestLocation.latitude},${assignedRequestData!.requestLocation.longitude}&travelmode=driving&dir_action=navigate';
        } else if (assignedRequestData!.requestStatus ==
            RequestStatus.ongoing) {
          mapUrl =
              'https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${assignedRequestData!.hospitalLocation.latitude},${assignedRequestData!.hospitalLocation.longitude}&travelmode=driving&dir_action=navigate';
        }
      }
    }
    try {
      if (mapUrl.isNotEmpty) {
        if (await canLaunchUrl(Uri.parse(mapUrl))) {
          await launchUrl(Uri.parse(mapUrl),
              mode: LaunchMode.externalApplication);
        } else {
          showSnackBar(
              text: 'googleNavigationError'.tr,
              snackBarType: SnackBarType.error);
          if (kDebugMode) {
            AppInit.logger.e('Could not open google maps navigation');
          }
        }
      }
    } catch (error) {
      showSnackBar(
          text: 'googleNavigationError'.tr, snackBarType: SnackBarType.error);
      if (kDebugMode) {
        AppInit.logger
            .e('Error launching google maps navigation: ${error.toString()}');
      }
    }
  }

  Future<void> startMapboxNavigation() async {
    if (assignedRequestData != null) {
      await MapBoxNavigation.instance
          .registerRouteEventListener(_onEmbeddedRouteEvent);
      late final WayPoint start;
      late final WayPoint destination;
      if (assignedRequestData!.requestStatus == RequestStatus.assigned) {
        start = WayPoint(
          name: 'ambulance'.tr,
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
          isSilent: false,
        );
        destination = WayPoint(
          name: 'requestLocation'.tr,
          latitude: assignedRequestData!.requestLocation.latitude,
          longitude: assignedRequestData!.requestLocation.longitude,
          isSilent: false,
        );
      } else if (assignedRequestData!.requestStatus == RequestStatus.ongoing) {
        start = WayPoint(
          name: 'ambulance'.tr,
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
          isSilent: false,
        );

        destination = WayPoint(
          name: assignedRequestData!.hospitalName,
          latitude: assignedRequestData!.hospitalLocation.latitude,
          longitude: assignedRequestData!.hospitalLocation.longitude,
          isSilent: false,
        );
      }
      final wayPoints = <WayPoint>[];
      wayPoints.add(start);
      wayPoints.add(destination);
      MapBoxNavigation.instance.startNavigation(
        wayPoints: wayPoints,
        options: MapBoxOptions(
          initialLatitude: currentLocation.latitude,
          initialLongitude: currentLocation.longitude,
          mode: MapBoxNavigationMode.driving,
          simulateRoute: false,
          language: "en",
          alternatives: true,
          allowsUTurnAtWayPoints: true,
          voiceInstructionsEnabled: true,
          isOptimized: true,
          longPressDestinationEnabled: false,
          animateBuildRoute: true,
          units: VoiceUnits.metric,
        ),
      );
    }
  }

  void onUserInformationPressed() async {
    if (assignedRequestData != null) {
      if (userRequestInfo == null) {
        showLoadingScreen();
        userRequestInfo = await firebaseEmployeeDataAccess.getUserInfo(
            userId: assignedRequestData!.userId);
        hideLoadingScreen();
      }
      if (userRequestInfo != null) {
        Get.to(
          () => EmployeeUserInformationPage(
            userInfo: userRequestInfo!,
          ),
          transition: getPageTransition(),
        );
      } else {
        showSnackBar(text: 'unknownError'.tr, snackBarType: SnackBarType.error);
      }
    }
  }

  void onMedicalInformationPressed() async {
    if (assignedRequestData != null) {
      Get.to(
        () => EmployeeMedicalInformationPage(
          medicalInfo: assignedRequestData!.medicalHistory!,
          patientAge: assignedRequestData!.patientAge ?? 'unknown',
          patientCondition: assignedRequestData!.patientCondition,
        ),
        transition: getPageTransition(),
      );
    } else {
      showSnackBar(text: 'unknownError'.tr, snackBarType: SnackBarType.error);
    }
  }

  Future<void> _onEmbeddedRouteEvent(navigationEvent) async {
    switch (navigationEvent.eventType) {
      case MapBoxEvent.progress_change:
        // String currentInstruction = '';
        // final progressEvent = navigationEvent.data as RouteProgressEvent;
        // if (progressEvent.currentStepInstruction != null) {
        //   if (!isLangEnglish()) {
        //     final newStepInstruction = progressEvent.currentStepInstruction!;
        //     if (currentInstruction != newStepInstruction) {
        //       textToSpeech(text: newStepInstruction);
        //       currentInstruction = newStepInstruction;
        //     }
        //   }
        // }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        break;
      case MapBoxEvent.route_build_failed:
        break;
      case MapBoxEvent.navigation_running:
        break;
      case MapBoxEvent.on_arrival:
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        break;
      default:
        break;
    }
  }

  Future<Polyline?> getRouteToLocation(
      {required LatLng fromLocation,
      required LatLng toLocation,
      required String routeId}) async {
    try {
      final directions = google_web_directions_service.GoogleMapsDirections(
        baseUrl: AppInit.isWeb ? "https://cors-anywhere.herokuapp.com/" : null,
        apiKey: googleMapsAPIKeyWeb,
      );
      await getRouteOperation?.cancel();
      getRouteOperation = CancelableOperation.fromFuture(
        directions.directionsWithLocation(
          google_web_directions_service.Location(
              lat: fromLocation.latitude, lng: fromLocation.longitude),
          google_web_directions_service.Location(
              lat: toLocation.latitude, lng: toLocation.longitude),
          travelMode: google_web_directions_service.TravelMode.driving,
          language: isLangEnglish() ? 'en' : 'ar',
        ),
      );
      final result = await getRouteOperation!.valueOrCancellation();
      if (result != null) {
        if (result.isOkay) {
          final route = result.routes.first;
          final leg = route.legs.first;
          final duration = leg.duration;
          routeToDestinationTime = duration.value.seconds.inMinutes;
          final polyline = route.overviewPolyline.points;
          final polylinePoints = PolylinePoints();
          final points = polylinePoints.decodePolyline(polyline);
          final latLngPoints = points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          latLngPoints.insert(0, fromLocation);
          latLngPoints.insert(latLngPoints.length, toLocation);
          final routePolyLine = Polyline(
            polylineId: PolylineId(routeId),
            color: Colors.black,
            points: latLngPoints,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
            geodesic: true,
          );
          return routePolyLine;
        }
      } else {
        if (kDebugMode) {
          print('route get canceled');
        }
      }
    } catch (err) {
      if (kDebugMode) print('error in getRouteToLocation ${err.toString()}');
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

  CameraPosition getInitialCameraPosition() {
    final cameraPosition = CameraPosition(
      target:
          locationAvailable.value ? currentLocationGetter() : hospitalLatLng,
      zoom: 15.5,
    );
    initialCameraLatLng = cameraPosition.target;
    return cameraPosition;
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
              }
            }
          } else if (status == ServiceStatus.disabled) {
            if (positionStreamInitialized) {
              currentPositionStream?.pause();
              if (kDebugMode) print('position listener paused');
            }
            locationServiceEnabled.value = false;
            displayAlertDialog(
              title: 'locationService'.tr,
              body: 'enableLocationService'.tr,
              color: SweetSheetColor.DANGER,
              positiveButtonText: 'ok'.tr,
              positiveButtonOnPressed: () {
                Get.back();
              },
            );
          }
        },
      );
    } catch (err) {
      if (kDebugMode) {
        print('error in setupLocationServiceListener ${err.toString()}');
      }
    }
  }

  void onLocationButtonPress() {
    if (mapPolyLines.isNotEmpty) {
      animateToLatLngBounds(
          latLngBounds: getLatLngBounds(latLngList: mapPolyLines.first.points));
    } else {
      if (locationAvailable.value) {
        animateCamera(locationLatLng: currentLocationGetter());
      } else {
        animateCamera(locationLatLng: hospitalLatLng);
      }
    }
  }

  void animateToLocation({required LatLng locationLatLng}) {
    if (googleMapControllerInit) {
      animateCamera(locationLatLng: locationLatLng);
    }
  }

  void animateToLatLngBounds({required LatLngBounds latLngBounds}) {
    if (googleMapControllerInit) {
      googleMapController
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 35));
    }
  }

  void onCameraIdle() {
    Future.delayed(const Duration(seconds: 1))
        .whenComplete(() => cameraMoved = false);
  }

  void onCameraMove(CameraPosition cameraPosition) {
    currentCameraLatLng = cameraPosition.target;
    cameraMoved = true;
  }

  void onMapTap(LatLng tappedPosition) {}

  void animateCamera({required LatLng locationLatLng}) {
    if (googleMapControllerInit) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: locationLatLng,
            zoom: 15.5,
          ),
        ),
      );
    }
  }

  void onLocationChanges() {
    if (!loggingOut) {
      if (hasAssignedRequest.value && assignedRequestData != null) {
        if (AuthenticationRepository.instance.userType == UserType.driver) {
          firebaseEmployeeDataAccess.updateDriverLocation(
              driverLocation: GeoPoint(
                  currentLocation.latitude, currentLocation.longitude));
        }
        updateRouteAndMap();
        if (assignedRequestData!.requestStatus == RequestStatus.assigned) {
          final distanceToRequest = GeoFirePoint.distanceBetween(
              to: Coordinates(
                  currentLocation.latitude, currentLocation.longitude),
              from: Coordinates(assignedRequestData!.requestLocation.latitude,
                  assignedRequestData!.requestLocation.longitude));

          if (distanceToRequest <= 0.6 && distanceToRequest >= 0.05) {
            if (!assignedRequestData!.notifiedNear) {
              assignedRequestData!.notifiedNear = true;
              firebaseEmployeeDataAccess
                  .sendNotification(
                userId: assignedRequestData!.userId,
                hospitalName: assignedRequestData!.hospitalName,
                notificationType: EmployeeNotificationType.ambulanceNear,
                requestId: assignedRequestData!.requestId,
              )
                  .then(
                (functionStatus) {
                  if (functionStatus == FunctionStatus.success) {
                    assignedRequestData!.notifiedNear = true;
                  } else {
                    assignedRequestData!.notifiedNear = false;
                  }
                },
              );
            }
          } else if (distanceToRequest < 0.05) {
            if (!assignedRequestData!.notifiedArrived) {
              assignedRequestData!.notifiedArrived = true;
              firebaseEmployeeDataAccess
                  .sendNotification(
                userId: assignedRequestData!.userId,
                hospitalName: assignedRequestData!.hospitalName,
                notificationType: EmployeeNotificationType.ambulanceArrived,
                requestId: assignedRequestData!.requestId,
              )
                  .then(
                (functionStatus) {
                  if (functionStatus == FunctionStatus.success) {
                    assignedRequestData!.notifiedArrived = true;
                  } else {
                    assignedRequestData!.notifiedArrived = false;
                  }
                },
              );
            }
          }
        }
      } else {
        if (AuthenticationRepository.instance.userType == UserType.driver) {
          firebaseEmployeeDataAccess.updateDriverLocation(
              driverLocation: GeoPoint(
                  currentLocation.latitude, currentLocation.longitude));
        }
        ambulanceMarker = Marker(
          markerId: kAmbulanceMarkerId,
          position: currentLocationGetter(),
          icon: ambulanceMarkerIcon,
          anchor: const Offset(0.5, 0.5),
          consumeTapEvents: true,
        );
        mapMarkersAnimated[kAmbulanceMarkerId] = ambulanceMarker!;
        animateCamera(locationLatLng: currentLocationGetter());
      }
    }
  }

  void getCurrentLocation() async {
    try {
      await Geolocator.getCurrentPosition(desiredAccuracy: accuracy)
          .then((locationPosition) {
        currentLocation = locationPosition;
        locationAvailable.value = true;
        onLocationChanges();
        if (kDebugMode) {
          print(
              'current location ${locationPosition.latitude.toString()}, ${locationPosition.longitude.toString()}');
        }
      });
      if (positionStreamInitialized) {
        await currentPositionStream?.cancel();
      }
      currentPositionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (Position? position) {
          if (position != null) {
            currentLocation = position;
            locationAvailable.value = true;
            onLocationChanges();
          }
          if (kDebugMode) {
            print(position == null
                ? 'current location from listener is Unknown'
                : 'current location from listener ${position.latitude.toString()}, ${position.longitude.toString()}');
          }
        },
      );
      positionStreamInitialized = true;
    } catch (err) {
      if (kDebugMode) print('error in position stream ${err.toString()}');
    }
  }

  LatLng currentLocationGetter() =>
      LatLng(currentLocation.latitude, currentLocation.longitude);

  @override
  void onClose() async {
    try {
      if (googleMapControllerInit && !AppInit.isWeb) {
        googleMapController.dispose();
      }
    } catch (err) {
      if (kDebugMode) print('error in onClose ${err.toString()}');
    }
    super.onClose();
  }

  Future<void> _loadMarkersIcon() async {
    await _getBytesFromAsset(kRequestLocationMarkerImg, 120).then((iconBytes) {
      requestLocationMarkerIcon = BitmapDescriptor.fromBytes(iconBytes);
    });
    await _getBytesFromAsset(kAmbulanceMarkerTopImg, 200).then((iconBytes) {
      ambulanceMarkerIcon = BitmapDescriptor.fromBytes(iconBytes);
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

  void loadAssignedRequest() {
    if (currentAssignedRequestId != null) {
      firebaseEmployeeDataAccess
          .getAssignedRequestInfo(requestId: currentAssignedRequestId!)
          .then((requestData) {
        assignedRequestLoaded.value = true;
        if (requestData != null) {
          assignedRequestData = requestData;
          onAssignedLoadedChanges();
        } else {
          showSnackBar(
              text: 'unknownError'.tr, snackBarType: SnackBarType.error);
        }
      });
    }
  }
}
