import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/enums.dart';
import '../../../general/general_functions.dart';
import '../../account/components/models.dart';
import '../components/making_request/components/normal_request_location_page.dart';

class MakingRequestInformationController extends GetxController {
  static MakingRequestInformationController get instance => Get.find();

  final notUserRequest = false.obs;

  //medical history
  var diseasesList = <DiseaseItem>[].obs;
  String backupPhoneNo = '';
  String selectedBloodType = '';
  String diabeticType = '';
  String hypertensivePatient = '';
  String heartPatient = '';
  final diseaseName = ''.obs;
  final highlightPatientCondition = false.obs;
  final highlightRequest = false.obs;
  final diseaseNameTextController = TextEditingController();
  final medicinesTextController = TextEditingController();
  final additionalInformationTextController = TextEditingController();
  final patientConditionTextController = TextEditingController();
  final requestTypeDropdownController = TextEditingController();
  final hypertensiveDropdownController = TextEditingController();
  final diabetesDropdownController = TextEditingController();
  final heartPatientDropdownController = TextEditingController();
  final bloodTypeDropdownController = TextEditingController();

  @override
  void onReady() async {
    requestTypeDropdownController.addListener(() {
      final requestValue = requestTypeDropdownController.text.trim();
      if (requestValue
              .compareTo(isLangEnglish() ? 'Someone else' : 'لشخص اخر') ==
          0) {
        highlightRequest.value = false;
        notUserRequest.value = true;
      } else {
        highlightRequest.value = false;
        notUserRequest.value = false;
      }
    });
    patientConditionTextController.addListener(() {
      if (patientConditionTextController.text.trim().isNotEmpty) {
        highlightPatientCondition.value = false;
      }
    });
    diseaseNameTextController.addListener(() {
      diseaseName.value = diseaseNameTextController.text.trim();
    });
    super.onReady();
  }

  Future<void> confirmRequestInformation() async {
    highlightPatientCondition.value =
        patientConditionTextController.text.isEmpty;
    final requestType = requestTypeDropdownController.text.trim();
    highlightRequest.value =
        requestType.compareTo(isLangEnglish() ? 'Select' : 'اختر') == 0 ||
            requestType.isEmpty;
    if (highlightPatientCondition.value || highlightRequest.value) {
      showSimpleSnackBar(
          text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    } else {
      Get.to(
        () => const NormalRequestLocationPage(),
        transition: getPageTransition(),
      );
    }
  }

  @override
  void onClose() {
    diseaseNameTextController.dispose();
    medicinesTextController.dispose();
    additionalInformationTextController.dispose();
    requestTypeDropdownController.dispose();
    hypertensiveDropdownController.dispose();
    diabetesDropdownController.dispose();
    bloodTypeDropdownController.dispose();
    heartPatientDropdownController.dispose();
    patientConditionTextController.dispose();
    super.onClose();
  }
}
