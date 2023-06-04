import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rolling_switch/rolling_switch.dart';

import '../../../../firebase_files/firebase_patient_access.dart';
import '../../../constants/enums.dart';
import '../../../general/general_functions.dart';
import '../components/addresses/add_address_page.dart';

class AddressesController extends GetxController {
  static AddressesController get instance => Get.find();

  final locationNameTextController = TextEditingController();
  final streetNameTextController = TextEditingController();
  final apartmentNumberTextController = TextEditingController();
  final floorNumberTextController = TextEditingController();
  final areaNameTextController = TextEditingController();
  final additionalInfoTextController = TextEditingController();

  var addressesList = <AddressItem>[].obs;

  RxBool highlightLocationName = false.obs;
  RxBool highlightStreetName = false.obs;
  RxBool highlightApartmentNumber = false.obs;
  RxBool highlightFloorNumber = false.obs;
  RxBool highlightArea = false.obs;

  bool makePrimary = false;
  final makePrimaryKey = GlobalKey<RollingSwitchState>();

  late final FirebasePatientDataAccess firebasePatientDataAccess;
  final addressesLoaded = false.obs;
  late GeoPoint addressLocation;
  final primaryAddressIndex = RxnInt();
  @override
  void onInit() async {
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
    loadAddresses();
    super.onInit();
  }

  @override
  void onReady() async {
    locationNameTextController.addListener(() {
      if (locationNameTextController.text.trim().isNotEmpty) {
        highlightLocationName.value = false;
      }
    });

    streetNameTextController.addListener(() {
      if (streetNameTextController.text.trim().isNotEmpty) {
        highlightStreetName.value = false;
      }
    });

    apartmentNumberTextController.addListener(() {
      if (apartmentNumberTextController.text.trim().isNotEmpty &&
          apartmentNumberTextController.text.isNum) {
        highlightApartmentNumber.value = false;
      }
    });

    floorNumberTextController.addListener(() {
      if (floorNumberTextController.text.trim().isNotEmpty &&
          apartmentNumberTextController.text.isNum) {
        highlightFloorNumber.value = false;
      }
    });

    areaNameTextController.addListener(() {
      if (areaNameTextController.text.trim().isNotEmpty) {
        highlightArea.value = false;
      }
    });
  }

  void loadAddresses() async {
    addressesList.value = await firebasePatientDataAccess.getSavedAddresses();
    for (final addressItem in addressesList) {
      if (addressItem.isPrimary) {
        primaryAddressIndex.value = addressesList.indexOf(addressItem);
      }
    }
    addressesLoaded.value = true;
  }

  void confirmAddressLocation({required LatLng confirmAddressLocation}) {
    addressLocation = GeoPoint(
        confirmAddressLocation.latitude, confirmAddressLocation.longitude);
    Get.to(() => const AddAddressPage(), transition: getPageTransition());
  }

  Future<void> checkAddress() async {
    highlightLocationName.value =
        locationNameTextController.text.trim().isEmpty;
    highlightStreetName.value = streetNameTextController.text.trim().isEmpty;
    highlightApartmentNumber.value =
        apartmentNumberTextController.text.trim().isEmpty;
    highlightFloorNumber.value = floorNumberTextController.text.trim().isEmpty;
    highlightArea.value = areaNameTextController.text.trim().isEmpty;

    if (!highlightLocationName.value &&
        !highlightStreetName.value &&
        !highlightApartmentNumber.value &&
        !highlightFloorNumber.value &&
        !highlightArea.value) {
      addNewAddress();
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  void addNewAddress() async {
    if (Get.context != null) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
    showLoadingScreen();
    final locationName = locationNameTextController.text.trim();
    final streetName = streetNameTextController.text.trim();
    final apartmentNumber = apartmentNumberTextController.text.trim();
    final floorNumber = floorNumberTextController.text.trim();
    final areaName = areaNameTextController.text.trim();
    final additionalInfo = additionalInfoTextController.text.trim();
    final addressItem = await firebasePatientDataAccess.addNewAddress(
      isPrimary: makePrimary,
      locationName: locationName,
      streetName: streetName,
      apartmentNumber: apartmentNumber,
      floorNumber: floorNumber,
      areaName: areaName,
      additionalInfo: additionalInfo,
      location: addressLocation,
    );
    hideLoadingScreen();
    if (addressItem != null) {
      addressesList.add(addressItem);
      if (addressesList.length == 1 || makePrimary) {
        updatePrimary(addressItem: addressItem);
      }
      locationNameTextController.clear();
      streetNameTextController.clear();
      apartmentNumberTextController.clear();
      floorNumberTextController.clear();
      areaNameTextController.clear();
      additionalInfoTextController.clear();
      Get.close(2);
      showSnackBar(
          text: 'addressSavedSuccess'.tr, snackBarType: SnackBarType.success);
    } else {
      hideLoadingScreen();
      showSnackBar(
          text: 'addressSavedError'.tr, snackBarType: SnackBarType.error);
    }
  }

  removeAddress({required AddressItem addressItem}) async {
    showLoadingScreen();
    final addressDocumentId = firebasePatientDataAccess.firestoreUserRef
        .collection('addresses')
        .doc(addressItem.addressId);
    final functionStatus = await firebasePatientDataAccess.deleteDocument(
        documentRef: addressDocumentId);
    hideLoadingScreen();
    if (functionStatus == FunctionStatus.success) {
      addressesList.remove(addressItem);
      if (addressesList.length == 1 && !addressesList.first.isPrimary) {
        updatePrimary(addressItem: addressesList.first);
      }
    } else if (functionStatus == FunctionStatus.failure) {
      showSnackBar(
          text: 'addressDeletionFailed'.tr, snackBarType: SnackBarType.error);
    }
  }

  void updatePrimary({required AddressItem addressItem}) async {
    await firebasePatientDataAccess
        .primarySetup(addressItem.addressId.toString());
    primaryAddressIndex.value = addressesList.indexOf(addressItem);
  }

  @override
  void onClose() {
    locationNameTextController.dispose();
    streetNameTextController.dispose();
    apartmentNumberTextController.dispose();
    floorNumberTextController.dispose();
    areaNameTextController.dispose();
    additionalInfoTextController.dispose();
    super.onClose();
  }
}
