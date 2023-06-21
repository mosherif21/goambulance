import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/no_localization_strings.dart';
import 'package:goambulance/src/features/account/controllers/addresses_controller.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_box_geocoder/map_box_geocoder.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../../constants/assets_strings.dart';
import '../../../constants/enums.dart';

class AddressesLocationController extends GetxController {
  static AddressesLocationController get instance => Get.find();

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
  final mapControllerCompleter = Completer<GoogleMapController>();
  late final GoogleMapController googleMapController;
  bool googleMapControllerInit = false;
  final mapEnabled = false.obs;
  bool allowedLocation = false;
  final searchedText = 'searchPlace'.tr.obs;
  late String mapStyle;
  late LatLng initialCameraLatLng;
  final cameraMoved = false.obs;

  //making request
  late String currentChosenLocationAddress;
  late LatLng currentCameraLatLng;
  late LatLng currentChosenLatLng;

  //geoQuery vars
  final geoFire = GeoFlutterFire();

  @override
  void onReady() async {
    await locationInit();
    if (!AppInit.isWeb) {
      setupLocationServiceListener();
    }
    await rootBundle.loadString(kMapStyle).then((style) => mapStyle = style);
    initMapController();
    super.onReady();
  }

  void assignedRequestChanges() {}

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
      // if (AppInit.isWeb) {
      //   animateCamera(locationLatLng: initialCameraLatLng);
      // }
    });
  }

  Future<void> onLocationPress() async {
    if (allowedLocation) {
      AddressesController.instance
          .confirmAddressLocation(confirmAddressLocation: currentChosenLatLng);
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
      MapBoxGeocoder geocoder = MapBoxGeocoder(mapboxAPIKey);
      final geocodeResult = await geocoder.reverseSearch(
        LatLon(latLng.latitude, latLng.longitude),
        params: const ReverseQueryParams(
          language: 'en',
          limit: 1,
        ),
      );
      final address = geocodeResult.features.first.placeName;
      currentChosenLocationAddress = address;
      allowedLocation = address.contains('Egypt');
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

  void enableMap() {
    if (!mapEnabled.value) {
      mapEnabled.value = true;
    }
  }

  void onLocationButtonPress() {
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
      if (positionStreamInitialized) await currentPositionStream?.cancel();
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
    super.onClose();
  }
}
