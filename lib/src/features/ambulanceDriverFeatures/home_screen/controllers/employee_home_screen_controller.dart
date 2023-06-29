import 'dart:async';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
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
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/models.dart';
import 'package:goambulance/src/features/requests/components/making_request/models.dart';
import 'package:goambulance/src/features/requests/components/requests_history/models.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/directions.dart'
    as google_web_directions_service;
import 'package:location/location.dart' as location;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../constants/enums.dart';
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
  final mapPolyLines = <Polyline>{}.obs;
  final mapMarkers = <Marker>{}.obs;
  int routeToDestinationTime = 0;
  Marker? requestLocationMarker;
  Marker? ambulanceMarker;
  Marker? hospitalMarker;

  late final BitmapDescriptor requestLocationMarkerIcon;
  late final BitmapDescriptor hospitalMarkerIcon;
  final mapControllerCompleter = Completer<GoogleMapController>();
  late final GoogleMapController googleMapController;
  bool googleMapControllerInit = false;
  final hospitalLoaded = false.obs;
  final hospitalDataAvailable = false.obs;
  late String mapStyle;
  late LatLng initialCameraLatLng;
  late LatLng hospitalLatLng;
  final cameraMoved = false.obs;
  final requestPanelController = PanelController();

  //making request
  late LatLng currentCameraLatLng;
  final hasAssignedRequest = false.obs;
  final assignedRequestLoaded = false.obs;
  final hospitalsLoaded = false.obs;
  final requestStatus = RequestStatus.non.obs;
  late RequestMakingModel currentRequestData;
  late final FirebaseAmbulanceEmployeeDataAccess firebaseEmployeeDataAccess;

  CancelableOperation<google_web_directions_service.DirectionsResponse?>?
      getRouteOperation;
  late final FirebaseFirestore _firestore;
  late final String userId;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      assignedRequestListener;
  late final HospitalModel hospitalInfo;

  final requestLocationWindowController = CustomInfoWindowController();
  // final hospitalWindowController = CustomInfoWindowController();
  // final ambulanceWindowController = CustomInfoWindowController();

  //geoQuery vars
  final geoFire = GeoFlutterFire();

  final notificationsCount = 0.obs;
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      notificationCountStreamSubscription;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      assignedRequestStreamSubscription;
  RequestDataModel? assignedRequestData;
  UserInfoRequestModel? userRequestInfo;
  @override
  void onReady() async {
    _firestore = FirebaseFirestore.instance;
    userId = AuthenticationRepository.instance.fireUser.value!.uid;
    firebaseEmployeeDataAccess = FirebaseAmbulanceEmployeeDataAccess.instance;
    loadHospitalInfo();
    initMapController();
    listenForNotificationCount();
    locationPermissionGranted.value = await handleLocationPermission();
    locationServiceEnabled.value = await location.Location().serviceEnabled();
    if (!AppInit.isWeb) {
      setupLocationServiceListener();
    }
    getCurrentLocation();
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
            onAssignedChanges();
            final requestId = snapshot.id;
            firebaseEmployeeDataAccess
                .getAssignedRequestInfo(requestId: requestId)
                .then((requestData) {
              if (requestData != null) {
                assignedRequestData = requestData;
                onAssignedLoadedChanges();
              }
            });
          }
        } else {
          if (hasAssignedRequest.value) {
            onNotAssignedChanges();
            if (assignedRequestLoaded.value) {
              onNotAssignedLoadedChanges();
            }
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
  }

  void onNotAssignedChanges() async {
    requestPanelController.close();
    hasAssignedRequest.value = false;
    Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
      animateCamera(
          locationLatLng: locationAvailable.value
              ? currentLocationGetter()
              : hospitalLatLng);
    });
  }

  void onAssignedLoadedChanges() async {
    assignedRequestLoaded.value = true;
  }

  void onNotAssignedLoadedChanges() async {
    assignedRequestLoaded.value = false;
  }

  Future<void> cancelListeners() async {
    await notificationCountStreamSubscription?.cancel();
    await assignedRequestStreamSubscription?.cancel();
    if (!AppInit.isWeb) {
      await serviceStatusStream?.cancel();
    }
    if (positionStreamInitialized) await currentPositionStream?.cancel();

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
      requestLocationWindowController.googleMapController = controller;
      // hospitalWindowController.googleMapController = controller;
      // ambulanceWindowController.googleMapController = controller;
      await _loadMarkersIcon();
      hospitalMarker = Marker(
        markerId: const MarkerId('hospital'),
        position: hospitalLatLng,
        icon: hospitalMarkerIcon,
        onTap: () => animateCamera(locationLatLng: hospitalLatLng),
      );
      mapMarkers.add(hospitalMarker!);
      if (AppInit.isWeb) {
        animateCamera(locationLatLng: initialCameraLatLng);
      }
      listenForAssignedRequests();
    });
  }

  void onStartNavigationPressed() async {
    if (locationPermissionGranted.value && locationServiceEnabled.value) {
      showLoadingScreen();
      currentLocation =
          await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
      hideLoadingScreen();
      startNavigation();
    } else {
      if (await handleLocationPermission() && await handleLocationService()) {
        showLoadingScreen();
        currentLocation =
            await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
        hideLoadingScreen();
        startNavigation();
      }
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
        ),
        transition: getPageTransition(),
      );
    } else {
      showSnackBar(text: 'unknownError'.tr, snackBarType: SnackBarType.error);
    }
  }

  void startNavigation() async {
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
      } else {
        start = WayPoint(
          name: 'ambulance'.tr,
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
          isSilent: false,
        );

        destination = WayPoint(
          name: assignedRequestData!.hospitalName,
          latitude: assignedRequestData!.hospitalLocation.latitude,
          longitude: assignedRequestData!.hospitalLocation.latitude,
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
          language: isLangEnglish() ? "en" : "ar",
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

  CameraPosition getInitialCameraPosition() {
    final cameraPosition = CameraPosition(
      target:
          locationAvailable.value ? currentLocationGetter() : hospitalLatLng,
      zoom: 15.5,
    );
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
              } else {
                getCurrentLocation();
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
      if (kDebugMode) print(err.toString());
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
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 80));
    }
  }

  void onCameraIdle() async {}

  void onCameraMove(CameraPosition cameraPosition) {
    currentCameraLatLng = cameraPosition.target;
    cameraMoved.value = true;
    if (requestLocationWindowController.onCameraMove != null) {
      requestLocationWindowController.onCameraMove!();
    }
    // if (hospitalWindowController.onCameraMove != null) {
    //   hospitalWindowController.onCameraMove!();
    // }
    // if (ambulanceWindowController.onCameraMove != null) {
    //   ambulanceWindowController.onCameraMove!();
    // }
  }

  void onMapTap(LatLng tappedPosition) {}

  void animateCamera({required LatLng locationLatLng}) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: locationLatLng,
          zoom: 15.5,
        ),
      ),
    );
  }

  void getCurrentLocation() async {
    try {
      await Geolocator.getCurrentPosition(desiredAccuracy: accuracy)
          .then((locationPosition) {
        currentLocation = locationPosition;
        locationAvailable.value = true;
        animateCamera(locationLatLng: currentLocationGetter());
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
      if (kDebugMode) print(err.toString());
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
      if (kDebugMode) print(err.toString());
    }
    requestLocationWindowController.dispose();
    // hospitalWindowController.dispose();
    // ambulanceWindowController.dispose();

    super.onClose();
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
}
// Future<void> initRequestListener({
//   required DocumentReference pendingRequestRef,
// }) async {
//   try {
//     pendingRequestListener = _firestore
//         .collection('pendingRequests')
//         .doc(pendingRequestRef.id)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.exists) {
//         final status = snapshot.data()!['status'].toString();
//         if (status == 'accepted') {
//           requestStatus.value = RequestStatus.accepted;
//         }
//       } else {
//         _firestore
//             .collection('assignedRequests')
//             .doc(pendingRequestRef.id)
//             .get()
//             .then((snapshot) {
//           if (snapshot.exists) {
//             assignedRequestChanges();
//           } else {
//             onRequestCanceledChanges();
//             showSnackBar(
//                 text: 'requestCanceled'.tr, snackBarType: SnackBarType.info);
//           }
//         });
//       }
//     });
//   } on FirebaseException catch (error) {
//     if (kDebugMode) print(error.toString());
//   } catch (err) {
//     if (kDebugMode) print(err.toString());
//   }
// }

// void confirmRequest() async {
//   if (selectedHospital.value != null) {
//     showLoadingScreen();
//     final requestInfo =
//         MakingRequestInformationController.instance.getRequestInfo();
//     final pendingRequestRef = _firestore.collection('pendingRequests').doc();
//     final requestData = RequestModel(
//       userId: userId,
//       hospitalId: selectedHospital.value!.hospitalId,
//       hospitalRequestInfo: requestInfo,
//       timestamp: Timestamp.now(),
//       requestLocation: GeoPoint(
//           currentChosenLatLng.latitude, currentChosenLatLng.longitude),
//       requestRef: pendingRequestRef,
//       hospitalLocation: GeoPoint(selectedHospital.value!.location.latitude,
//           selectedHospital.value!.location.longitude),
//       status: 'pending',
//       hospitalName: selectedHospital.value!.name,
//       hospitalGeohash: selectedHospital.value!.geohash,
//     );
//     final functionStatus = await firebasePatientDataAccess.requestHospital(
//         requestInfo: requestData);
//
//     if (functionStatus == FunctionStatus.success) {
//       if (requestInfo.sendSms != null) {
//         if (requestInfo.sendSms!) {
//           sendRequestSms(
//               requestId: pendingRequestRef.id,
//               patientName: userName,
//               sosSmsType: SosSmsType.normalRequestSMS);
//         }
//       }
//       currentRequestData = requestData;
//       requestStatus.value = RequestStatus.pending;
//       initRequestListener(pendingRequestRef: pendingRequestRef);
//     } else {
//       showSnackBar(
//           text: 'errorOccurred'.tr, snackBarType: SnackBarType.error);
//     }
//     hideLoadingScreen();
//   }
// }

// void cancelRequest() {
//   displayAlertDialog(
//     title: 'confirm'.tr,
//     body: 'cancelRequestConfirm'.tr,
//     positiveButtonText: 'yes'.tr,
//     negativeButtonText: 'no'.tr,
//     positiveButtonOnPressed: () async {
//       Get.back();
//       showLoadingScreen();
//       await pendingRequestListener?.cancel();
//       final functionStatus = await firebasePatientDataAccess
//           .cancelHospitalRequest(requestInfo: currentRequestData);
//       hideLoadingScreen();
//       if (functionStatus == FunctionStatus.success) {
//         onRequestCanceledChanges();
//       }
//     },
//     negativeButtonOnPressed: () => Get.back(),
//     mainIcon: Icons.cancel_outlined,
//     color: SweetSheetColor.DANGER,
//   );
// }

// void onRequestCanceledChanges() {
//   requestStatus.value = RequestStatus.non;
//   onRefresh();
// }

// Future<void> loadHospitals() async {
//   hospitalsLoaded.value = false;
//   selectedHospital.value = null;
//   await getHospitals();
//   hospitalsLoaded.value = true;
// }
//

// Future<void> choosingHospitalChanges() async {
//   clearSearchedHospitals();
//   choosingHospital.value = true;
//   hospitalsPanelController.open();
//   requestLocationMarker = Marker(
//     markerId: MarkerId('requestLocation'.tr),
//     position: currentChosenLatLng,
//     icon: requestLocationMarkerIcon,
//     consumeTapEvents: true,
//   );
//   mapMarkers.add(requestLocationMarker!);
//   Future.delayed(const Duration(milliseconds: 100)).whenComplete(
//       () => animateToLocation(locationLatLng: currentChosenLatLng));
//   loadHospitals();
// }

// void clearHospitalRoute() {
//   mapPolyLines.clear();
//   if (requestLocationWindowController.hideInfoWindow != null) {
//     requestLocationWindowController.hideInfoWindow!();
//   }
//   if (hospitalWindowController.hideInfoWindow != null) {
//     hospitalWindowController.hideInfoWindow!();
//   }
//   if (hospitalMarker != null) {
//     if (mapMarkers.contains(hospitalMarker)) {
//       mapMarkers.remove(hospitalMarker);
//     }
//   }
// }

// void clearSearchedHospitals() {
//   clearHospitalRoute();
//   skipCount = 0;
//   searchedHospitals.value = [];
// }

// void choosingRequestLocationChanges() async {
//   choosingHospital.value = false;
//   hospitalsLoaded.value = false;
//   hospitalsPanelController.close();
//   await getHospitalsOperation?.cancel();
//   await getRouteOperation?.cancel();
//   selectedHospital.value = null;
//   if (mapMarkers.contains(requestLocationMarker)) {
//     mapMarkers.remove(requestLocationMarker!);
//   }
//   if (requestLocationWindowController.hideInfoWindow != null) {
//     requestLocationWindowController.hideInfoWindow!();
//   }
//   if (hospitalWindowController.hideInfoWindow != null) {
//     hospitalWindowController.hideInfoWindow!();
//   }
//   Future.delayed(const Duration(milliseconds: 100)).whenComplete(
//       () => animateToLocation(locationLatLng: currentChosenLatLng));
//   clearSearchedHospitals();
// }

// Future<List<HospitalModel>> getHospitalsList() async {
//   double searchRadius = 3;
//   double maxRadius = 15;
//   List<DocumentSnapshot<Object?>> hospitalGeoDocuments = [];
//   try {
//     final center = geoFire.point(
//         latitude: currentChosenLatLng.latitude,
//         longitude: currentChosenLatLng.longitude);
//     final collectionReference = _firestore.collection('hospitalsLocations');
//     while (hospitalGeoDocuments.length < pageSize &&
//         searchRadius <= maxRadius &&
//         choosingHospital.value) {
//       if (kDebugMode) print('search radius $searchRadius');
//       final stream = geoFire
//           .collection(collectionRef: collectionReference)
//           .withinAsSingleStreamSubscription(
//             center: center,
//             radius: searchRadius,
//             field: 'g',
//             strictMode: true,
//           )
//           .skip(skipCount)
//           .take(pageSize);
//       try {
//         hospitalGeoDocuments =
//             await stream.first.timeout(const Duration(seconds: 2));
//       } on TimeoutException {
//         if (kDebugMode) print('search timed out');
//       }
//       searchRadius += 2;
//     }
//   } on FirebaseException catch (error) {
//     if (kDebugMode) print(error.toString());
//   } catch (e) {
//     if (kDebugMode) print(e.toString());
//   }
//   final List<HospitalModel> hospitalsDataDocuments = [];
//   for (final hospitalDoc in hospitalGeoDocuments) {
//     final geoPoint = hospitalDoc['g.geopoint'] as GeoPoint;
//     final geohash = hospitalDoc['g.geohash'] as String;
//     final foundHospital = HospitalModel(
//       hospitalId: hospitalDoc.id,
//       name: hospitalDoc['name'].toString(),
//       avgPrice: hospitalDoc['avgAmbulancePrice'].toString(),
//       location: LatLng(geoPoint.latitude, geoPoint.longitude),
//       geohash: geohash,
//     );
//     hospitalsDataDocuments.add(foundHospital);
//   }
//   return hospitalsDataDocuments;
// }

// Future<void> getHospitals() async {
//   await getHospitalsOperation?.cancel();
//   getHospitalsOperation = CancelableOperation.fromFuture(getHospitalsList());
//   final hospitalsDocuments =
//       await getHospitalsOperation!.valueOrCancellation();
//   if (hospitalsDocuments != null) {
//     if (kDebugMode) {
//       print('hospitals got count ${hospitalsDocuments.length}');
//     }
//     if (hospitalsDocuments.isEmpty && skipCount == 0) {
//       showSnackBar(
//           text: 'nearHospitalsNotFound'.tr, snackBarType: SnackBarType.info);
//     } else if (hospitalsDocuments.isNotEmpty) {
//       searchedHospitals.value = hospitalsDocuments;
//       if (skipCount == 0) {
//         selectedHospital.value = hospitalsDocuments[0];
//         hospitalMarker = Marker(
//           markerId: const MarkerId('hospital'),
//           position: selectedHospital.value!.location,
//           icon: hospitalMarkerIcon,
//           consumeTapEvents: true,
//         );
//         mapMarkers.add(hospitalMarker!);
//         animateToLatLngBounds(
//             latLngBounds: getLatLngBounds(latLngList: [
//           currentChosenLatLng,
//           selectedHospital.value!.location
//         ]));
//         getRouteToLocation(
//           fromLocation: currentChosenLatLng,
//           toLocation: selectedHospital.value!.location,
//           routeId: 'routeToHospital',
//         ).then((routePolyLine) {
//           if (routePolyLine != null) {
//             if (requestLocationWindowController.addInfoWindow != null) {
//               requestLocationWindowController.addInfoWindow!(
//                 MarkerWindowInfo(
//                   time: routeToDestinationTime,
//                   title: 'requestLocation'.tr,
//                   windowType: MarkerWindowType.requestLocation,
//                   onTap: () =>
//                       animateToLocation(locationLatLng: currentChosenLatLng),
//                 ),
//                 currentChosenLatLng,
//               );
//             }
//             if (hospitalWindowController.addInfoWindow != null) {
//               hospitalWindowController.addInfoWindow!(
//                 MarkerWindowInfo(
//                   time: routeToDestinationTime,
//                   title: selectedHospital.value!.name,
//                   windowType: MarkerWindowType.hospitalLocation,
//                   onTap: () => animateToLocation(
//                       locationLatLng: selectedHospital.value!.location),
//                 ),
//                 selectedHospital.value!.location,
//               );
//             }
//             mapPolyLines.add(routePolyLine);
//             animateToLatLngBounds(
//                 latLngBounds:
//                     getLatLngBounds(latLngList: routePolyLine.points));
//           }
//         });
//       }
//       skipCount += hospitalsDocuments.length;
//       if (kDebugMode) print('skip count $skipCount');
//     }
//   } else {
//     if (kDebugMode) {
//       print('hospitals get canceled');
//     }
//   }
// }

// void onHospitalChosen({required int hospitalIndex}) async {
//   clearHospitalRoute();
//   final hospitalItem = searchedHospitals[hospitalIndex];
//   hospitalMarker = Marker(
//     markerId: const MarkerId('hospital'),
//     position: hospitalItem.location,
//     icon: hospitalMarkerIcon,
//     anchor: const Offset(0.5, 0.5),
//     consumeTapEvents: true,
//   );
//   mapMarkers.add(hospitalMarker!);
//   animateToLatLngBounds(
//       latLngBounds: getLatLngBounds(
//           latLngList: [currentChosenLatLng, hospitalItem.location]));
//   selectedHospital.value = hospitalItem;
//   getRouteToLocation(
//     fromLocation: currentChosenLatLng,
//     toLocation: hospitalItem.location,
//     routeId: 'routeToHospital',
//   ).then((routePolyLine) {
//     if (routePolyLine != null) {
//       if (requestLocationWindowController.addInfoWindow != null) {
//         requestLocationWindowController.addInfoWindow!(
//           MarkerWindowInfo(
//             time: routeToDestinationTime,
//             title: 'requestLocation'.tr,
//             windowType: MarkerWindowType.requestLocation,
//             onTap: () =>
//                 animateToLocation(locationLatLng: currentChosenLatLng),
//           ),
//           currentChosenLatLng,
//         );
//       }
//       if (hospitalWindowController.addInfoWindow != null) {
//         hospitalWindowController.addInfoWindow!(
//           MarkerWindowInfo(
//             time: routeToDestinationTime,
//             title: hospitalItem.name,
//             windowType: MarkerWindowType.hospitalLocation,
//             onTap: () =>
//                 animateToLocation(locationLatLng: hospitalItem.location),
//           ),
//           hospitalItem.location,
//         );
//       }
//       mapPolyLines.add(routePolyLine);
//       animateToLatLngBounds(
//           latLngBounds: getLatLngBounds(latLngList: routePolyLine.points));
//     }
//   });
// }

// late final BitmapDescriptor ambulanceMarkerIcon;
// await _getBytesFromAsset(kAmbulanceMarkerImg, 120).then((iconBytes) {
//   ambulanceMarkerIcon = BitmapDescriptor.fromBytes(iconBytes);
// });
// ambulanceMarker = Marker(
//   markerId: const MarkerId('ambulance'),
//   position: LatLng(currentChosenLatLng.latitude + 0.002,
//       currentChosenLatLng.longitude + 0.002),
//   icon: ambulanceMarkerIcon,
//   infoWindow: InfoWindow(
//     title: 'ambulancePinDesc'.tr,
//   ),
//   onTap: () => animateToLocation(
//       locationLatLng: LatLng(currentChosenLatLng.latitude + 0.002,
//           currentChosenLatLng.longitude + 0.002)),
// );
// mapMarkers.add(ambulanceMarker!);
// mapMarkers.remove(ambulanceMarker!);
