import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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

  late final String userId;
  late final UserInformation userInfo;
  late final AuthenticationRepository authRep;
  final addressesLoaded = false.obs;

  @override
  void onInit() async {
    authRep = AuthenticationRepository.instance;
    userInfo = authRep.userInfo;
    userId = authRep.fireUser.value!.uid;
    loadAddresses();
    super.onInit();
  }

  @override
  void onReady() async {}

  void loadAddresses() {
    try {
      final userAddressesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('addresses');
      userAddressesRef.get().then((addressesSnapshot) {
        for (var addressesDoc in addressesSnapshot.docs) {
          currentAddressesDocIds.add(addressesDoc.id);
          final addressesData = addressesDoc.data();
          addressesList.add(
            AddressItem(
                locationName: addressesData['locationName'].toString(),
                streetName: addressesData['streetName'].toString(),
                apartmentNumber: addressesData['apartmentNumber'].toString(),
                floorNumber: addressesData['floorNumber'].toString(),
                areaName: addressesData['areaName'].toString(),
                additionalInfo: addressesData['additionalInfo'].toString()),
          );
        }
        addressesLoaded.value = true;
      });
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
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
    final AddressItem addressItem = AddressItem(
        locationName: locationName,
        streetName: streetName,
        apartmentNumber: apartmentNumber,
        floorNumber: floorNumber,
        areaName: areaName,
        additionalInfo: additionalInfo);
    final addressData = SavedAddressesModel(
        addressName: locationName, addressesList: addressesList);

    final functionStatus = await FirebasePatientDataAccess.instance
        .addNewAddress(
            savedAddressData: addressItem,
            currentAddressDocIds: currentAddressesDocIds);
    if (functionStatus == FunctionStatus.success) {
      hideLoadingScreen();
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
