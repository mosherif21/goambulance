import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';

import '../../../general/common_widgets/regular_bottom_sheet.dart';

class SosMessageController extends GetxController {
  static SosMessageController get instance => Get.find();

  //vars
  final contactName = ''.obs;
  final phoneNumber = ''.obs;
  final highlightSosMessage = false.obs;
  final sosMessageDataLoaded = false.obs;
  String sosMessage = '';
  final contactsList = <ContactItem>[].obs;
  late final FirebasePatientDataAccess firebasePatientDataAccess;
  //controllers
  final contactNameTextController = TextEditingController();
  final sosMessageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    firebasePatientDataAccess = FirebasePatientDataAccess.instance;
  }

  @override
  void onReady() async {
    super.onReady();
    sosMessageController.addListener(() {
      if (sosMessageController.text.trim().isNotEmpty) {
        highlightSosMessage.value = true;
      }
    });
    contactNameTextController.addListener(() {
      contactName.value = contactNameTextController.text.trim();
    });
    contactsList.value = await firebasePatientDataAccess.getEmergencyContacts();
    sosMessage = AuthenticationRepository.instance.userInfo!.sosMessage;
    sosMessageDataLoaded.value = true;
  }

  addContact() {
    RegularBottomSheet.hideBottomSheet();
    contactsList.add(ContactItem(
        contactName: contactName.value, contactNumber: phoneNumber.value));
    contactNameTextController.clear();
  }

  @override
  void onClose() {
    contactNameTextController.dispose();
    sosMessageController.dispose();
    super.onClose();
  }
}

class ContactItem {
  final String contactName;
  final String contactNumber;
  ContactItem({
    required this.contactName,
    required this.contactNumber,
  });
  Map<String, dynamic> toJson() {
    return {
      'contactName': contactName,
      'contactNumber': contactNumber,
    };
  }
}
