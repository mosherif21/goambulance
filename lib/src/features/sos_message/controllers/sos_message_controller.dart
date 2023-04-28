import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../general/common_widgets/regular_bottom_sheet.dart';

class SosMessageController extends GetxController {
  static SosMessageController get instance => Get.find();

  //vars
  final contactName = ''.obs;
  final phoneNumber = ''.obs;
  final highlightSosMessage = false.obs;
  final sosMessageDataLoaded = true.obs;
  String sosMessage = '';
  final contactsList = <ContactItem>[].obs;
  //controllers
  final contactNameTextController = TextEditingController();
  final sosMessageController = TextEditingController();

  @override
  void onInit() {
    //
    super.onInit();
  }

  @override
  void onReady() {
    sosMessageController.addListener(() {
      if (sosMessageController.text.trim().isNotEmpty) {
        highlightSosMessage.value = true;
      }
    });
    contactNameTextController.addListener(() {
      contactName.value = contactNameTextController.text.trim();
    });
    super.onReady();
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
