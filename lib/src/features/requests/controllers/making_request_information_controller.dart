import 'dart:async';

import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../general/general_functions.dart';
import '../../account/components/models.dart';
import '../components/making_request/components/normal_request_location_page.dart';

class MakingRequestInformationController extends GetxController {
  static MakingRequestInformationController get instance => Get.find();

  final notUserRequest = false.obs;

  //medical history
  var diseasesList = <DiseaseItem>[].obs;
  String selectedBloodType = '';
  String diabeticType = '';
  String hypertensivePatient = '';
  String heartPatient = '';

  final diseaseNameTextController = TextEditingController();
  final medicinesTextController = TextEditingController();
  final medicalHistoryScrollController = ScrollController();
  final additionalInformationTextController = TextEditingController();
  List<CoolDropdownItem<String>> requestTypeItems = [];
  final requestTypeDropdownController = DropdownController();
  List<CoolDropdownItem<String>> hypertensiveItems = [];
  final hypertensiveDropdownController = DropdownController();
  List<CoolDropdownItem<String>> diabetesItems = [];
  final diabetesDropdownController = DropdownController();
  List<CoolDropdownItem<String>> heartPatientItems = [];
  final heartPatientDropdownController = DropdownController();
  List<CoolDropdownItem<String>> bloodTypeItems = [];
  final bloodTypeDropdownController = DropdownController();
  @override
  void onInit() {
    List<String> requestPersons = [
      'forMe'.tr,
      'someoneElse'.tr,
    ];
    List<String> binaryChoose = [
      'don\'tKnow'.tr,
      'yes'.tr,
      'no'.tr,
    ];
    final List<String> bloodTypes = [
      'don\'tKnow'.tr,
      'A+',
      'O+',
      'B+',
      'AB+',
      'A-',
      'O-',
      'B-',
      'AB-',
    ];
    List<String> diabetesTypesHim = [
      'don\'tKnow'.tr,
      'no'.tr,
      'Type 1',
      'Type 2',
    ];
    for (var i = 0; i < requestPersons.length; i++) {
      requestTypeItems.add(CoolDropdownItem<String>(
          label: requestPersons[i], value: requestPersons[i]));
    }
    for (var i = 0; i < binaryChoose.length; i++) {
      hypertensiveItems.add(CoolDropdownItem<String>(
          label: binaryChoose[i], value: binaryChoose[i]));
      heartPatientItems.add(CoolDropdownItem<String>(
          label: binaryChoose[i], value: binaryChoose[i]));
    }
    for (var i = 0; i < diabetesTypesHim.length; i++) {
      diabetesItems.add(CoolDropdownItem<String>(
          label: diabetesTypesHim[i], value: diabetesTypesHim[i]));
    }
    for (var i = 0; i < bloodTypes.length; i++) {
      bloodTypeItems.add(
          CoolDropdownItem<String>(label: bloodTypes[i], value: bloodTypes[i]));
    }
    super.onInit();
  }

  @override
  void onReady() async {
    //
    super.onReady();
  }

  Future<void> confirmRequestInformation() async {
    showLoadingScreen();
    hideLoadingScreen();
    Get.to(
      () => const NormalRequestLocationPage(),
      transition: getPageTransition(),
    );
  }

  @override
  void onClose() {
    diseaseNameTextController.dispose();
    medicinesTextController.dispose();
    medicalHistoryScrollController.dispose();
    additionalInformationTextController.dispose();
    requestTypeDropdownController.dispose();
    hypertensiveDropdownController.dispose();
    diabetesDropdownController.dispose();
    bloodTypeDropdownController.dispose();
    heartPatientDropdownController.dispose();
    super.onClose();
  }
}
