import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../../firebase_files/firebase_patient_access.dart';
import '../../../constants/enums.dart';
import '../../../general/general_functions.dart';

class AddressesController extends GetxController {
  static AddressesController get instance => Get.find();

  final locationNameTextController = TextEditingController();
  final streetNameTextController = TextEditingController();
  final apartmentNumberTextController = TextEditingController();
  final floorNumberTextController = TextEditingController();
  final areaNameTextController = TextEditingController();
  final additionalInfoTextController = TextEditingController();
  final savedAddressesScrollController = ScrollController();

  var addressesList = <AddressItem>[].obs;
  final locationName = ''.obs;
  final apartmentNumber = ''.obs;
  final floorNumber = ''.obs;
  final areaName = ''.obs;
  final additionalInfo = ''.obs;
  var currentAddressesDocIds = <String>[];

  RxBool highlightLocationName = false.obs;
  RxBool highlightStreetName = false.obs;
  RxBool highlightApartmentNumber = false.obs;
  RxBool highlightFloorNumber = false.obs;
  RxBool highlightArea = false.obs;

  late final String userId;
  late final UserInformation userInfo;
  late final AuthenticationRepository authRep;
  late final FirebasePatientDataAccess firebasePatientDataAccess;
  final addressesLoaded = false.obs;

  @override
  void onInit() async {
    authRep = AuthenticationRepository.instance;
    userInfo = authRep.userInfo;
    userId = authRep.fireUser.value!.uid;
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
      if (apartmentNumberTextController.text.trim().isNotEmpty) {
        highlightApartmentNumber.value = false;
      }
    });

    floorNumberTextController.addListener(() {
      if (floorNumberTextController.text.trim().isNotEmpty) {
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
    addressesLoaded.value = true;
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
    showLoadingScreen();
    final locationName = locationNameTextController.text.trim();
    final streetName = streetNameTextController.text.trim();
    final apartmentNumber = apartmentNumberTextController.text.trim();
    final floorNumber = floorNumberTextController.text.trim();
    final areaName = areaNameTextController.text.trim();
    final additionalInfo = additionalInfoTextController.text.trim();

    final addressItem = await firebasePatientDataAccess.addNewAddress(
        locationName: locationName,
        streetName: streetName,
        apartmentNumber: apartmentNumber,
        floorNumber: floorNumber,
        areaName: areaName,
        additionalInfo: additionalInfo);

    hideLoadingScreen();
    if (addressItem != null) {
      addressesList.add(addressItem);
      locationNameTextController.clear();
      streetNameTextController.clear();
      apartmentNumberTextController.clear();
      floorNumberTextController.clear();
      areaNameTextController.clear();
      additionalInfoTextController.clear();
      showSnackBar(
          text: 'medicalHistorySavedSuccess'.tr,
          snackBarType: SnackBarType.success);
    } else {
      hideLoadingScreen();
      showSnackBar(
          text: 'medicalHistorySavedError'.tr,
          snackBarType: SnackBarType.error);
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
    } else if (functionStatus == FunctionStatus.failure) {
      showSnackBar(
          text: 'deletingEmergencyContactFailed'.tr,
          snackBarType: SnackBarType.error);
    }
  }

  // void addAddress() {
  //   if (locationName.value.isNotEmpty) {
  //     final locationName = locationNameTextController.text.trim();
  //     final streetName = streetNameTextController.text.trim();
  //     final apartmentNumber = apartmentNumberTextController.text.trim();
  //     final floorNumber = floorNumberTextController.text.trim();
  //     final areaName = areaNameTextController.text.trim();
  //     final additionalInfo = additionalInfoTextController.text.trim();
  //     addressesList.add(AddressItem(
  //         locationName: locationName,
  //         streetName: streetName,
  //         apartmentNumber: apartmentNumber,
  //         floorNumber: floorNumber,
  //         areaName: areaName,
  //         additionalInfo: additionalInfo));
  //     locationNameTextController.clear();
  //     streetNameTextController.clear();
  //     apartmentNumberTextController.clear();
  //     floorNumberTextController.clear();
  //     areaNameTextController.clear();
  //     additionalInfoTextController.clear();
  //     RegularBottomSheet.hideBottomSheet();
  //   }
  // }

  @override
  void onClose() {
    locationNameTextController.dispose();
    streetNameTextController.dispose();
    apartmentNumberTextController.dispose();
    floorNumberTextController.dispose();
    areaNameTextController.dispose();
    additionalInfoTextController.dispose();
    savedAddressesScrollController.dispose();
    super.onClose();
  }
}
