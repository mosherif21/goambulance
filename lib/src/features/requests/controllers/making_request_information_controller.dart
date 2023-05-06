import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/general_functions.dart';
import '../../account/components/models.dart';
import '../components/making_request/components/normal_request_location_page.dart';
import '../components/making_request/models.dart';

class MakingRequestInformationController extends GetxController {
  static MakingRequestInformationController get instance => Get.find();

  final notUserRequest = false.obs;

  //medical history
  var diseasesList = <DiseaseItem>[].obs;
  String backupPhoneNo = '';
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
        patientConditionTextController.text.trim().isEmpty;
    final requestType = requestTypeDropdownController.text.trim();
    highlightRequest.value =
        requestType == 'selectValue'.tr || requestType.isEmpty;
    if (highlightPatientCondition.value || highlightRequest.value) {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    } else {
      Get.to(
        () => const NormalRequestLocationPage(),
        transition: getPageTransition(),
      );
    }
  }

  Future<RequestInfoModel> getRequestInfo() async {
    final patientCondition = patientConditionTextController.text.trim();
    final relationToPatient = requestTypeDropdownController.text.trim();
    final bloodType = requestTypeDropdownController.text.trim();
    final diabetic = requestTypeDropdownController.text.trim();
    final hypertensive = requestTypeDropdownController.text.trim();
    final heartPatient = requestTypeDropdownController.text.trim();
    final additionalInformation =
        additionalInformationTextController.text.trim();
    // final additionalInformationTextController = TextEditingController();
    // final patientConditionTextController = TextEditingController();
    // final requestTypeDropdownController = TextEditingController();
    // final hypertensiveDropdownController = TextEditingController();
    // final diabetesDropdownController = TextEditingController();
    // final heartPatientDropdownController = TextEditingController();
    // final bloodTypeDropdownController = TextEditingController();
    return RequestInfoModel(
      relationToPatient: relationToPatient,
      patientCondition: patientCondition,
      backupNumber: backupPhoneNo,
      medicalHistory: relationToPatient == 'someoneElse'.tr
          ? MedicalHistoryModel(
              bloodType: bloodType,
              diabetic: diabetic,
              hypertensive: hypertensive,
              heartPatient: heartPatient,
              additionalInformation: additionalInformation,
              diseasesList: diseasesList,
            )
          : null,
    );
  }

  void addDiseaseItem() {
    if (diseaseName.value.isNotEmpty) {
      final diseaseMedicines = medicinesTextController.text.trim();
      diseasesList.add(DiseaseItem(
          diseaseName: diseaseName.value, diseaseMedicines: diseaseMedicines));
      diseaseNameTextController.clear();
      medicinesTextController.clear();
      RegularBottomSheet.hideBottomSheet();
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
