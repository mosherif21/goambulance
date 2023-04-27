import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyContactsController extends GetxController {
  static EmergencyContactsController get instance => Get.find();

  //vars
  final contactName = ''.obs;
  final phoneNumber = ''.obs;

  //controllers
  final contactNameTextController = TextEditingController();

  @override
  void onInit() {
    //
    super.onInit();
  }

  @override
  void onReady() {
    contactNameTextController.addListener(() {
      contactName.value = contactNameTextController.text.trim();
    });
    super.onReady();
  }

  addContact() {}
  @override
  void onClose() {
    contactNameTextController.dispose();
    super.onClose();
  }
}
