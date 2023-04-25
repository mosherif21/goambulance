import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/no_localization_strings.dart';
import 'package:goambulance/src/features/requests/components/making_request/models.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../../constants/app_init_constants.dart';
import '../../../constants/assets_strings.dart';
import '../../../constants/enums.dart';

class MakingRequestLocationController extends GetxController {
  static MakingRequestLocationController get instance => Get.find();

  //Location settings
  final locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 40,
  );
  final accuracy = LocationAccuracy.high;

  //maps vars
  final RxSet<Polyline> mapPolyLines = <Polyline>{}.obs;
  final RxSet<Marker> mapMarkers = <Marker>{}.obs;
  late Polyline? routeToHospital;
  late Marker? requestLocationMarker;
  late Marker? ambulanceMarker;
  late Marker? hospitalMarker;

  late BitmapDescriptor requestLocationMarkerIcon;
  late BitmapDescriptor ambulanceMarkerIcon;
  late BitmapDescriptor hospitalMarkerIcon;
  final Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();
  late final GoogleMapController googleMapController;
  bool googleMapControllerInit = false;

  //location permissions and services vars
  final locationAvailable = false.obs;
  final mapLoading = false.obs;
  late Position currentLocation;
  late LatLng searchedLocation;
  late StreamSubscription<ServiceStatus>? serviceStatusStream;
  late StreamSubscription<Position>? currentPositionStream;
  bool positionStreamInitialized = false;
  final locationPermissionGranted = false.obs;
  final locationServiceEnabled = false.obs;
  final mapEnabled = false.obs;
  bool allowedLocation = false;
  final searchedText = 'searchPlace'.tr.obs;
  late String mapStyle;
  late LatLng initialCameraLatLng;
  bool cameraMoved = false;
  final RxDouble mapPinMargin = 85.0.obs;
  final PanelController hospitalsPanelController = PanelController();

  //making request
  late String currentChosenLocationAddress;
  late LatLng currentChosenLatLng;
  final choosingHospital = false.obs;

  late Rx<HospitalModel?> selectedHospital = Rx<HospitalModel?>(null);
  final RxList<HospitalModel> searchedHospitals = <HospitalModel>[].obs;

  @override
  void onReady() async {
    await locationInit();
    setupLocationServiceListener();
    await rootBundle.loadString(kMapStyle).then((style) => mapStyle = style);
    initMapController();
    await _loadMarkersIcon();
    super.onReady();
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
    });
  }

  Future<void> onRequestPress() async {
    if (allowedLocation) {
      await choosingHospitalChanges();
      if (kDebugMode) {
        print('chosen location LatLng: $currentChosenLatLng');
        print('chosen location address: $currentChosenLocationAddress');
      }
    } else {
      showSimpleSnackBar(
        text: 'locationNotAllowed'.tr,
        snackBarType: SnackBarType.error,
      );
    }
  }

  Future<void> choosingHospitalChanges() async {
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
        () => {animateToLocation(locationLatLng: currentChosenLatLng)});
    await getHospitals();
    hospitalMarker = Marker(
      markerId: const MarkerId('hospital'),
      position: selectedHospital.value!.location,
      icon: hospitalMarkerIcon,
      infoWindow: InfoWindow(
        title: 'hospitalLocationPinDesc'.tr,
      ),
      onTap: () =>
          animateToLocation(locationLatLng: selectedHospital.value!.location),
    );
    mapMarkers.add(hospitalMarker!);
    routeToHospital = await getRouteToLocation(
      fromLocation: currentChosenLatLng,
      toLocation: selectedHospital.value!.location,
      routeId: 'routeToHospital',
    );
    animateToLatLngBounds(
        latLngBounds: getLatLngBounds(latLngList: routeToHospital!.points));
    if (routeToHospital != null) {
      mapPolyLines.add(routeToHospital!);
    }
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
  }

  void choosingRequestLocationChanges() async {
    choosingHospital.value = false;
    hospitalsPanelController.close();
    Future.delayed(const Duration(milliseconds: 100)).whenComplete(
        () => {animateToLocation(locationLatLng: currentChosenLatLng)});
    searchedHospitals.value = [];
    selectedHospital.value = null;
    if (mapMarkers.contains(requestLocationMarker)) {
      mapMarkers.remove(requestLocationMarker!);
    }
    clearHospitalRoute();
  }

  void clearHospitalRoute() {
    if (mapPolyLines.contains(routeToHospital)) {
      mapPolyLines.remove(routeToHospital);
    }
    if (mapMarkers.contains(hospitalMarker)) {
      mapMarkers.remove(hospitalMarker);
    }
  }

  Future<void> getHospitals() async {
    if (searchedHospitals.isEmpty) {
      final hospitals = <HospitalModel>[];
      hospitals.add(
        HospitalModel(
          hospitalId: '',
          name: 'hospital name 1',
          avgPrice: 'EGP 33',
          location: const LatLng(31.237669953932324, 29.954293705523015),
          timeFromLocation: 2,
        ),
      );
      hospitals.add(
        HospitalModel(
          hospitalId: '',
          name: 'hospital name 2',
          avgPrice: 'EGP 44',
          location: const LatLng(31.232469953932325, 29.954293705523016),
          timeFromLocation: 3,
        ),
      );
      hospitals.add(
        HospitalModel(
          hospitalId: '',
          name: 'hospital name 3',
          avgPrice: 'EGP 22',
          location: const LatLng(31.235369953932326, 29.954293705523017),
          timeFromLocation: 4,
        ),
      );
      hospitals.add(
        HospitalModel(
          hospitalId: '',
          name: 'hospital name 4',
          avgPrice: 'EGP 77',
          location: const LatLng(31.239269953932327, 29.954393705523018),
          timeFromLocation: 5,
        ),
      );
      await Future.delayed(const Duration(seconds: 5));
      searchedHospitals.value = hospitals;
      selectedHospital.value = hospitals[0];
    }
  }

  void onHospitalChosen({required HospitalModel hospitalItem}) async {
    clearHospitalRoute();
    hospitalMarker = Marker(
      markerId: const MarkerId('hospital'),
      position: hospitalItem.location,
      icon: hospitalMarkerIcon,
      infoWindow: InfoWindow(
        title: 'hospitalLocationPinDesc'.tr,
      ),
      anchor: const Offset(0.5, 0.5),
      onTap: () => animateToLocation(locationLatLng: hospitalItem.location),
    );
    mapMarkers.add(hospitalMarker!);
    selectedHospital.value = hospitalItem;
    routeToHospital = await getRouteToLocation(
      fromLocation: currentChosenLatLng,
      toLocation: hospitalItem.location,
      routeId: 'routeToHospital',
    );
    animateToLatLngBounds(
        latLngBounds: getLatLngBounds(latLngList: routeToHospital!.points));
    if (routeToHospital != null) {
      mapPolyLines.add(routeToHospital!);
    }
  }

  Future<Polyline?> getRouteToLocation(
      {required LatLng fromLocation,
      required LatLng toLocation,
      required String routeId}) async {
    try {
      List<LatLng> polylineCoordinates = [];
      if (!AppInit.isWeb) {
        PolylineResult polylineResult =
            await PolylinePoints().getRouteBetweenCoordinates(
          googleMapsAPIKey,
          PointLatLng(fromLocation.latitude, fromLocation.longitude),
          PointLatLng(toLocation.latitude, toLocation.longitude),
          travelMode: TravelMode.driving,
          optimizeWaypoints: true,
        );
        if (polylineResult.points.isNotEmpty) {
          if (polylineResult.points.isNotEmpty) {
            for (var point in polylineResult.points) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }
          }
        }
      } else {
        polylineCoordinates
            .add(LatLng(fromLocation.latitude, fromLocation.longitude));
        polylineCoordinates
            .add(LatLng(toLocation.latitude, toLocation.longitude));
      }
      if (kDebugMode) print('route found successfully');
      return Polyline(
        polylineId: PolylineId(routeId),
        color: Colors.black,
        points: polylineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        geodesic: true,
      );
    } catch (err) {
      if (kDebugMode) print(err.toString());
      return null;
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
        apiKey: googleMapsAPIKey,
        hint: 'searchPlace'.tr,
        onError: (response) {
          if (kDebugMode) print(response.errorMessage ?? '');
        },
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
    final addressesInfo = await Geocoder2.getDataFromCoordinates(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      googleMapApiKey: googleMapsAPIKey,
      language: isLangEnglish() ? 'en' : 'ar',
    );
    final address = addressesInfo.address;
    currentChosenLocationAddress = address;
    checkAllowedLocation(countryCode: addressesInfo.countryCode);
    return address;
  }

  Future<LatLng> getLocationFromAddress({required String address}) async {
    currentChosenLocationAddress = address;
    final location = await Geocoder2.getDataFromAddress(
      address: address,
      googleMapApiKey: googleMapsAPIKey,
      language: isLangEnglish() ? 'en' : 'ar',
    );
    checkAllowedLocation(countryCode: location.countryCode);
    return LatLng(location.latitude, location.longitude);
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

  void animateToCurrentLocation() {
    if (locationAvailable.value) {
      animateCamera(locationLatLng: currentLocationGetter());
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
            .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 30));
      }
    }
  }

  void onCameraIdle() async {
    if (mapEnabled.value) {
      if (googleMapControllerInit) {
        try {
          searchedText.value = 'loading'.tr;
          String address = '';
          if (!cameraMoved) {
            currentChosenLatLng = LatLng(
                initialCameraLatLng.latitude, initialCameraLatLng.longitude);
          }
          address = await getAddressFromLocation(latLng: currentChosenLatLng);
          searchedText.value = allowedLocation ? address : 'notAllowed'.tr;
        } catch (err) {
          if (kDebugMode) print(err.toString());
        }
      }
    }
  }

  void onCameraMove(CameraPosition cameraPosition) {
    if (!choosingHospital.value) {
      currentChosenLatLng = cameraPosition.target;
      cameraMoved = true;
    }
  }

  void animateCamera({required LatLng locationLatLng}) {
    mapPinMargin.value = 90;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: locationLatLng,
        zoom: 15.5,
      ),
    ));
  }

  void getCurrentLocation() async {
    try {
      mapLoading.value = true;
      await Geolocator.getCurrentPosition(desiredAccuracy: accuracy).then(
        (locationPosition) {
          currentLocation = locationPosition;
          locationAvailable.value = true;
          enableMap();
          if (kDebugMode) {
            print(
                'current location ${locationPosition.latitude.toString()}, ${locationPosition.longitude.toString()}');
          }
        },
      );

      positionStreamInitialized = true;
      currentPositionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (Position? position) {
          if (position != null) {
            currentLocation = position;
            locationAvailable.value = true;
            enableMap();
          }
          if (kDebugMode) {
            print(position == null
                ? 'current location is Unknown'
                : 'current location ${position.latitude.toString()}, ${position.longitude.toString()}');
          }
        },
      );
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }

  LatLng currentLocationGetter() =>
      LatLng(currentLocation.latitude, currentLocation.longitude);

  @override
  void onClose() async {
    await serviceStatusStream?.cancel();
    if (googleMapControllerInit) googleMapController.dispose();
    if (positionStreamInitialized) await currentPositionStream!.cancel();
    super.onClose();
  }

  Future<void> _loadMarkersIcon() async {
    await _getBytesFromAsset(kRequestLocationMarkerImg, 130).then((iconBytes) {
      requestLocationMarkerIcon = BitmapDescriptor.fromBytes(iconBytes);
    });
    await _getBytesFromAsset(kAmbulanceMarkerImg, 130).then((iconBytes) {
      ambulanceMarkerIcon = BitmapDescriptor.fromBytes(iconBytes);
    });
    await _getBytesFromAsset(kHospitalMarkerImg, 150).then((iconBytes) {
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
