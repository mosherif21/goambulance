import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SosMessageController extends GetxController {
  static SosMessageController get instance => Get.find();

  //vars
  final contactName = ''.obs;
  final phoneNumber = ''.obs;
  final highlightSosMessage = false.obs;
  String sosMessage = '';

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

  addContact() {}
  @override
  void onClose() {
    contactNameTextController.dispose();
    sosMessageController.dispose();
    super.onClose();
  }
}
