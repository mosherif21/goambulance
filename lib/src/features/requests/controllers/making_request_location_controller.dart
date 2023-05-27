import 'dart:async';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/constants/no_localization_strings.dart';
import 'package:goambulance/src/features/requests/components/making_request/models.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/directions.dart'
    as google_web_directions_service;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../../constants/assets_strings.dart';
import '../../../constants/enums.dart';
import 'making_request_information_controller.dart';

class MakingRequestLocationController extends GetxController {
  static MakingRequestLocationController get instance => Get.find();

  //location permissions and services vars
  final locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 40,
  );
  final accuracy = LocationAccuracy.high;
  final locationAvailable = false.obs;
  final mapLoading = false.obs;
  late Position currentLocation;
  late LatLng searchedLocation;
  StreamSubscription<ServiceStatus>? serviceStatusStream;
  StreamSubscription<Position>? currentPositionStream;
  bool positionStreamInitialized = false;
  final locationPermissionGranted = false.obs;
  final locationServiceEnabled = false.obs;

  //maps vars
  final mapPolyLines = <Polyline>{}.obs;
  final mapMarkers = <Marker>{}.obs;
  final routeToHospitalTime = ''.obs;
  Marker? requestLocationMarker;
  Marker? ambulanceMarker;
  Marker? hospitalMarker;

  late final BitmapDescriptor requestLocationMarkerIcon;
  late final BitmapDescriptor hospitalMarkerIcon;
  final mapControllerCompleter = Completer<GoogleMapController>();
  late final GoogleMapController googleMapController;
  bool googleMapControllerInit = false;
  final mapEnabled = false.obs;
  bool allowedLocation = false;
  final searchedText = 'searchPlace'.tr.obs;
  late String mapStyle;
  late LatLng initialCameraLatLng;
  final cameraMoved = false.obs;
  final hospitalsPanelController = PanelController();
  RefreshController hospitalsRefreshController =
      RefreshController(initialRefresh: false);

  //making request
  late String currentChosenLocationAddress;
  late LatLng currentCameraLatLng;
  late LatLng currentChosenLatLng;
  final choosingHospital = false.obs;
  final hospitalsLoaded = false.obs;
  final requestStatus = RequestStatus.notRequested.obs;
  late RequestModel currentRequestData;
  late final FirebasePatientDataAccess firebasePatientDataAccess;
  final selectedHospital = Rx<HospitalModel?>(null);
  int skipCount = 0;
  static const pageSize = 6;

  final searchedHospitals = <HospitalModel>[].obs;
  CancelableOperation<List<DocumentSnapshot<Object?>>>? getHospitalsOperation;
  CancelableOperation<List<HospitalModel>>? getHospitalsDataOperation;
  CancelableOperation<google_web_directions_service.DirectionsResponse?>?
      getRouteOperation;
  late final FirebaseFirestore _firestore;
  late final String userId;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      pendingRequestListener;

  //geoQuery vars
  final geoFire = GeoFlutterFire();

  @override
  void onReady() async {
    _firestore = FirebaseFirestore.instance;
    userId = AuthenticationRepository.instance.fireUser.value!.uid;
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    await locationInit();
    if (!AppInit.isWeb) {
      setupLocationServiceListener();
    }
    await rootBundle.loadString(kMapStyle).then((style) => mapStyle = style);
    initMapController();
    await _loadMarkersIcon();
    super.onReady();
  }

  Future<void> initRequestListener({
    required DocumentReference pendingRequestRef,
  }) async {
    try {
      pendingRequestListener = _firestore
          .collection('pendingRequests')
          .doc(pendingRequestRef.id)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final status = snapshot.data()!['status'].toString();
          if (status == 'accepted') {
            requestStatus.value = RequestStatus.requestAccepted;
          }
        } else {
          _firestore
              .collection('assignedRequests')
              .doc(pendingRequestRef.id)
              .get()
              .then((snapshot) {
            if (snapshot.exists) {
              assignedRequestChanges();
            } else {
              onRequestCanceledChanges();
              showSnackBar(
                  text: 'requestCanceled'.tr, snackBarType: SnackBarType.info);
            }
          });
        }
      });
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }

  void assignedRequestChanges() {}

  void confirmRequest() async {
    if (selectedHospital.value != null) {
      showLoadingScreen();
      final requestInfo =
          MakingRequestInformationController.instance.getRequestInfo();
      final pendingRequestRef = _firestore.collection('pendingRequests').doc();
      final requestData = RequestModel(
        userId: userId,
        hospitalId: selectedHospital.value!.hospitalId,
        hospitalRequestInfo: requestInfo,
        timestamp: Timestamp.now(),
        requestLocation: GeoPoint(
            currentChosenLatLng.latitude, currentChosenLatLng.longitude),
        requestRef: pendingRequestRef,
        hospitalLocation: GeoPoint(selectedHospital.value!.location.latitude,
            selectedHospital.value!.location.longitude),
        status: 'pending',
        hospitalName: selectedHospital.value!.name,
      );
      final functionStatus = await firebasePatientDataAccess.requestHospital(
          requestInfo: requestData);

      if (functionStatus == FunctionStatus.success) {
        currentRequestData = requestData;
        requestStatus.value = RequestStatus.requestPending;
        initRequestListener(pendingRequestRef: pendingRequestRef);
      }
      hideLoadingScreen();
    }
  }

  void cancelRequest() {
    displayAlertDialog(
      title: 'confirm'.tr,
      body: 'cancelRequestConfirm'.tr,
      positiveButtonText: 'yes'.tr,
      negativeButtonText: 'no'.tr,
      positiveButtonOnPressed: () async {
        Get.back();
        showLoadingScreen();
        pendingRequestListener?.cancel();
        final functionStatus = await firebasePatientDataAccess
            .cancelHospitalRequest(requestInfo: currentRequestData);
        hideLoadingScreen();
        if (functionStatus == FunctionStatus.success) {
          onRequestCanceledChanges();
        }
      },
      negativeButtonOnPressed: () => Get.back(),
      mainIcon: Icons.cancel_outlined,
      color: SweetSheetColor.DANGER,
    );
  }

  void onRequestCanceledChanges() {
    requestStatus.value = RequestStatus.notRequested;
    onRefresh();
  }

  Future<void> locationInit() async {
    showLoadingScreen();
    await handleLocationService().then((locationService) {
      locationServiceEnabled.value = locationService;
      setupLocationPermission();
    });
    hideLoadingScreen();
  }

  Future<void> setupLocationPermission() async {
    await handleLocationPermission().then(
      (permissionGranted) {
        locationPermissionGranted.value = permissionGranted;
        if (permissionGranted && locationServiceEnabled.value) {
          getCurrentLocation();
        }
      },
    );
  }

  void initMapController() {
    mapControllerCompleter.future.then((controller) {
      googleMapController = controller;
      controller.setMapStyle(mapStyle);
      googleMapControllerInit = true;
      if (AppInit.isWeb) {
        animateCamera(locationLatLng: initialCameraLatLng);
      }
    });
  }

  void onRefresh() async {
    clearSearchedHospitals();
    loadHospitals();
    hospitalsRefreshController.refreshToIdle();
    hospitalsRefreshController.resetNoData();
  }

  Future<void> loadHospitals() async {
    hospitalsLoaded.value = false;
    selectedHospital.value = null;
    await getHospitals();
    hospitalsLoaded.value = true;
  }

  void onLoadMore() async {
    final oldSkipCount = skipCount;
    await getHospitals();
    if (oldSkipCount < skipCount) {
      hospitalsRefreshController.loadComplete();
    } else {
      hospitalsRefreshController.loadNoData();
    }
  }

  Future<void> onRequestPress() async {
    if (allowedLocation) {
      await choosingHospitalChanges();
      if (kDebugMode) {
        print('chosen location LatLng: $currentChosenLatLng');
        print('chosen location address: $currentChosenLocationAddress');
      }
    } else {
      showSnackBar(
        text: 'locationNotAllowed'.tr,
        snackBarType: SnackBarType.error,
      );
    }
  }

  Future<void> choosingHospitalChanges() async {
    clearSearchedHospitals();
    choosingHospital.value = true;
    hospitalsPanelController.open();
    requestLocationMarker = Marker(
      markerId: MarkerId('requestLocation'.tr),
      position: currentChosenLatLng,
      icon: requestLocationMarkerIcon,
      infoWindow: InfoWindow(
        title: 'requestLocationPinDesc'.tr,
      ),
      onTap: () => animateToLocation(locationLatLng: currentChosenLatLng),
    );
    mapMarkers.add(requestLocationMarker!);
    Future.delayed(const Duration(milliseconds: 100)).whenComplete(
        () => animateToLocation(locationLatLng: currentChosenLatLng));
    loadHospitals();
  }

  void clearHospitalRoute() {
    routeToHospitalTime.value = '';
    mapPolyLines.clear();
    if (hospitalMarker != null) {
      if (mapMarkers.contains(hospitalMarker)) {
        googleMapController.hideMarkerInfoWindow(hospitalMarker!.markerId);
        mapMarkers.remove(hospitalMarker);
      }
    }
  }

  void clearSearchedHospitals() {
    clearHospitalRoute();
    skipCount = 0;
    searchedHospitals.value = [];
  }

  void onBackPressed() {
    if (choosingHospital.value &&
        requestStatus.value == RequestStatus.notRequested) {
      choosingRequestLocationChanges();
    } else if (choosingHospital.value &&
        requestStatus.value != RequestStatus.notRequested) {
      Get.close(2);
    } else if (!choosingHospital.value &&
        requestStatus.value == RequestStatus.notRequested) {
      Get.back();
    }
  }

  Future<bool> onWillPop() {
    if (choosingHospital.value &&
        requestStatus.value == RequestStatus.notRequested) {
      choosingRequestLocationChanges();
      return Future.value(false);
    } else if (choosingHospital.value &&
        requestStatus.value != RequestStatus.notRequested) {
      Get.close(2);
      return Future.value(true);
    } else if (!choosingHospital.value &&
        requestStatus.value == RequestStatus.notRequested) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  void choosingRequestLocationChanges() async {
    choosingHospital.value = false;
    hospitalsLoaded.value = false;
    hospitalsPanelController.close();
    getHospitalsOperation?.cancel();
    getHospitalsDataOperation?.cancel();
    getRouteOperation?.cancel();

    selectedHospital.value = null;
    if (mapMarkers.contains(requestLocationMarker)) {
      mapMarkers.remove(requestLocationMarker!);
    }
    Future.delayed(const Duration(milliseconds: 100)).whenComplete(
        () => animateToLocation(locationLatLng: currentChosenLatLng));
    clearSearchedHospitals();
  }

  Future<List<DocumentSnapshot<Object?>>> getHospitalsList() async {
    double searchRadius = 3;
    double maxRadius = 15;
    List<DocumentSnapshot<Object?>> hospitalsDocuments =
        <DocumentSnapshot<Object?>>[];
    try {
      while (hospitalsDocuments.length < pageSize &&
          searchRadius <= maxRadius &&
          choosingHospital.value) {
        if (kDebugMode) print('search radius $searchRadius');
        GeoFirePoint center = geoFire.point(
            latitude: currentChosenLatLng.latitude,
            longitude: currentChosenLatLng.longitude);

        final collectionReference = _firestore.collection('hospitalsLocations');

        Stream<List<DocumentSnapshot>> stream = geoFire
            .collection(collectionRef: collectionReference)
            .withinAsSingleStreamSubscription(
              center: center,
              radius: searchRadius,
              field: 'position',
              strictMode: true,
            )
            .skip(skipCount)
            .take(pageSize);
        try {
          hospitalsDocuments =
              await stream.first.timeout(const Duration(seconds: 2));
        } on TimeoutException {
          if (kDebugMode) print('search timed out');
        }
        searchRadius += 2;
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return hospitalsDocuments;
  }

  Future<void> getHospitals() async {
    List<DocumentSnapshot<Object?>> hospitalsDocuments = [];
    getHospitalsOperation?.cancel();
    getHospitalsOperation = CancelableOperation.fromFuture(getHospitalsList());
    final returnedHospitals =
        await getHospitalsOperation!.valueOrCancellation();
    if (returnedHospitals != null) {
      hospitalsDocuments = returnedHospitals;
      if (kDebugMode) {
        print('hospitals got count ${hospitalsDocuments.length}');
      }
      if (hospitalsDocuments.isEmpty && skipCount == 0) {
        showSnackBar(
            text: 'nearHospitalsNotFound'.tr, snackBarType: SnackBarType.info);
      } else if (hospitalsDocuments.isNotEmpty) {
        getHospitalsDataOperation?.cancel();
        getHospitalsDataOperation = CancelableOperation.fromFuture(
            getHospitalsDataDocuments(hospitalsDocuments: hospitalsDocuments));
        final returnedDataHospitals =
            await getHospitalsDataOperation!.valueOrCancellation();
        if (returnedDataHospitals != null) {
          searchedHospitals.value = returnedDataHospitals;
          if (skipCount == 0) {
            selectedHospital.value = returnedDataHospitals[0];
            hospitalMarker = Marker(
              markerId: const MarkerId('hospital'),
              position: selectedHospital.value!.location,
              icon: hospitalMarkerIcon,
              infoWindow: InfoWindow(
                title:
                    '${selectedHospital.value!.name} (${'hospitalLocationPinDesc'.tr})',
              ),
              onTap: () => animateToLocation(
                  locationLatLng: selectedHospital.value!.location),
            );
            mapMarkers.add(hospitalMarker!);
            getRouteToLocation(
              fromLocation: currentChosenLatLng,
              toLocation: selectedHospital.value!.location,
              routeId: 'routeToHospital',
            );
          }
        }
        skipCount += hospitalsDocuments.length;
        if (kDebugMode) print('skip count $skipCount');
      } else {
        if (kDebugMode) {
          print('hospitals data get canceled');
        }
      }
    } else {
      if (kDebugMode) {
        print('hospitals get canceled');
      }
    }
  }

  Future<List<HospitalModel>> getHospitalsDataDocuments(
      {required List<DocumentSnapshot<Object?>> hospitalsDocuments}) async {
    List<HospitalModel> hospitalsDataDocuments = [];
    try {
      final hospitalsRef = _firestore.collection('hospitals');
      for (var hospitalsDocument in hospitalsDocuments) {
        final String hospitalId = hospitalsDocument.id;
        final docSnap = await hospitalsRef.doc(hospitalId).get();
        if (docSnap.exists) {
          final hospitalDoc = docSnap.data()!;
          GeoPoint geoPoint = hospitalDoc['location'] as GeoPoint;
          final foundHospital = HospitalModel(
            hospitalId: hospitalId,
            name: hospitalDoc['name'].toString(),
            avgPrice: hospitalDoc['avgAmbulancePrice'].toString(),
            location: LatLng(geoPoint.latitude, geoPoint.longitude),
          );
          hospitalsDataDocuments.add(foundHospital);
        }
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return hospitalsDataDocuments;
  }

  void onHospitalChosen({required int hospitalIndex}) async {
    clearHospitalRoute();
    final hospitalItem = searchedHospitals[hospitalIndex];
    hospitalMarker = Marker(
      markerId: const MarkerId('hospital'),
      position: hospitalItem.location,
      icon: hospitalMarkerIcon,
      infoWindow: InfoWindow(
        title: '${hospitalItem.name} (${'hospitalLocationPinDesc'.tr})',
      ),
      anchor: const Offset(0.5, 0.5),
      onTap: () => animateToLocation(locationLatLng: hospitalItem.location),
    );
    selectedHospital.value = hospitalItem;
    mapMarkers.add(hospitalMarker!);
    getRouteToLocation(
      fromLocation: currentChosenLatLng,
      toLocation: hospitalItem.location,
      routeId: 'routeToHospital',
    );
  }

  Future<void> getRouteToLocation(
      {required LatLng fromLocation,
      required LatLng toLocation,
      required String routeId}) async {
    try {
      final directions = google_web_directions_service.GoogleMapsDirections(
        baseUrl: AppInit.isWeb ? "https://cors-anywhere.herokuapp.com/" : null,
        apiKey: googleMapsAPIKeyWeb,
      );
      getRouteOperation?.cancel();
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
          routeToHospitalTime.value = duration.text;
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
          animateToLatLngBounds(
              latLngBounds: getLatLngBounds(latLngList: routePolyLine.points));
          mapPolyLines.add(routePolyLine);
        }
      } else {
        if (kDebugMode) {
          print('route get canceled');
        }
      }
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
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

  Future<void> googlePlacesSearch({required BuildContext context}) async {
    try {
      final predictions = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleMapsAPIKeyWeb,
        hint: 'searchPlace'.tr,
        onError: (response) {
          if (kDebugMode) print(response.errorMessage ?? '');
        },
        proxyBaseUrl:
            AppInit.isWeb ? 'https://cors-anywhere.herokuapp.com/' : null,
        region: 'EG',
        cursorColor: Colors.black,
        mode: Mode.overlay,
        language: isLangEnglish() ? 'en' : 'ar',
        backArrowIcon: const Icon(Icons.close, color: Colors.black),
      );
      if (predictions != null && predictions.description != null) {
        searchedLocation =
            await getLocationFromAddress(address: predictions.description!);
        enableMap();
        animateToLocation(locationLatLng: searchedLocation);
      }
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }

  CameraPosition getInitialCameraPosition() {
    final cameraPosition = CameraPosition(
      target:
          locationAvailable.value ? currentLocationGetter() : searchedLocation,
      zoom: 15.5,
    );
    initialCameraLatLng = cameraPosition.target;
    return cameraPosition;
  }

  Future<String> getAddressFromLocation({required LatLng latLng}) async {
    try {
      currentChosenLatLng = latLng;
      final addressesInfo = await Geocoder2.getDataFromCoordinates(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        googleMapApiKey: googleMapsAPIKeyWeb,
        language: isLangEnglish() ? 'en' : 'ar',
      );
      final address = addressesInfo.address;
      currentChosenLocationAddress = address;
      checkAllowedLocation(countryCode: addressesInfo.countryCode);
      return address;
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
    return '';
  }

  Future<LatLng> getLocationFromAddress({required String address}) async {
    currentChosenLocationAddress = address;
    final location = await Geocoder2.getDataFromAddress(
      address: address,
      googleMapApiKey: googleMapsAPIKeyWeb,
      language: isLangEnglish() ? 'en' : 'ar',
    );
    checkAllowedLocation(countryCode: location.countryCode);
    return currentChosenLatLng = LatLng(location.latitude, location.longitude);
  }

  void checkAllowedLocation({required String countryCode}) =>
      allowedLocation = countryCode.compareTo('EG') == 0;

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

  void enableMap() => mapEnabled.value = true;

  void onLocationButtonPress() {
    if (mapPolyLines.isNotEmpty) {
      animateToLatLngBounds(
          latLngBounds: getLatLngBounds(latLngList: mapPolyLines.first.points));
    } else {
      if (locationAvailable.value) {
        animateCamera(locationLatLng: currentLocationGetter());
      }
    }
  }

  void animateToLocation({required LatLng locationLatLng}) {
    if (mapEnabled.value) {
      if (googleMapControllerInit) {
        animateCamera(locationLatLng: locationLatLng);
      }
    }
  }

  void animateToLatLngBounds({required LatLngBounds latLngBounds}) {
    if (mapEnabled.value) {
      if (googleMapControllerInit) {
        googleMapController
            .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 40));
      }
    }
  }

  void onCameraIdle() async {
    if (mapEnabled.value) {
      if (googleMapControllerInit) {
        searchedText.value = 'loading'.tr;
        String address = '';
        if (!cameraMoved.value) {
          currentCameraLatLng = LatLng(
              initialCameraLatLng.latitude, initialCameraLatLng.longitude);
        }
        address = await getAddressFromLocation(latLng: currentCameraLatLng);
        if (address.isNotEmpty) {
          searchedText.value = allowedLocation ? address : 'notAllowed'.tr;
        } else {
          searchedText.value = 'addressNotFound'.tr;
        }
      }
    }
  }

  void onCameraMove(CameraPosition cameraPosition) {
    currentCameraLatLng = cameraPosition.target;
    cameraMoved.value = true;
  }

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
      mapLoading.value = true;
      await Geolocator.getCurrentPosition(desiredAccuracy: accuracy)
          .then((locationPosition) {
        currentLocation = locationPosition;
        locationAvailable.value = true;
        enableMap();
        if (kDebugMode) {
          print(
              'current location ${locationPosition.latitude.toString()}, ${locationPosition.longitude.toString()}');
        }
      });
      if (positionStreamInitialized) {
        currentPositionStream?.cancel();
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
                ? 'current location is Unknown'
                : 'current location ${position.latitude.toString()}, ${position.longitude.toString()}');
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
      if (!AppInit.isWeb) {
        await serviceStatusStream?.cancel();
      }
      hospitalsRefreshController.dispose();
      if (positionStreamInitialized) await currentPositionStream?.cancel();
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
    if (requestStatus.value != RequestStatus.notRequested) {
      pendingRequestListener?.cancel();
    }

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
