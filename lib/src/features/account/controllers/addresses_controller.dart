import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';

class AddressesController extends GetxController {
  static AddressesController get instance => Get.find();

  final locationNameTextController = TextEditingController();
  final addressesTextController = TextEditingController();
  final savedAddressesScrollController = ScrollController();

  var addressesList = <AddressItem>[].obs;
  final addressName = ''.obs;
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
      final userDiseasesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('addresses');
      userDiseasesRef.get().then((addressesSnapshot) {
        for (var addressesDoc in addressesSnapshot.docs) {
          currentAddressesDocIds.add(addressesDoc.id);
          final addressesData = addressesDoc.data();
          addressesList.add(
            AddressItem(
              addressName: addressesData['diseaseName'].toString(),
              address: addressesData['diseaseMedicines'].toString(),
            ),
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

  void addDiseaseItem() {
    if (addressName.value.isNotEmpty) {
      final address = addressesTextController.text.trim();
      addressesList
          .add(AddressItem(addressName: addressName.value, address: address));
      locationNameTextController.clear();
      addressesTextController.clear();
      RegularBottomSheet.hideBottomSheet();
    }
  }

  @override
  void onClose() {
    locationNameTextController.dispose();
    addressesTextController.dispose();
    savedAddressesScrollController.dispose();
    super.onClose();
  }
}
