import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:rolling_switch/rolling_switch.dart';

import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/general_functions.dart';
import '../../account/components/models.dart';
import '../components/making_request/components/normal_request_location_page.dart';
import '../components/making_request/models.dart';

class MakingRequestInformationController extends GetxController {
  static MakingRequestInformationController get instance => Get.find();

  final userRequest = true.obs;

  //medical history
  var diseasesList = <DiseaseItem>[].obs;
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
  bool sendSms = false;
  final sendSosPrimaryKey = GlobalKey<RollingSwitchState>();

  @override
  void onReady() async {
    requestTypeDropdownController.addListener(() {
      final requestValue = requestTypeDropdownController.text.trim();
      if (requestValue.compareTo('someoneElse'.tr) == 0) {
        highlightRequest.value = false;
        userRequest.value = false;
      } else {
        highlightRequest.value = false;
        userRequest.value = true;
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
        requestType.compareTo('selectValue'.tr) == 0 || requestType.isEmpty;
    if (highlightPatientCondition.value || highlightRequest.value) {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    } else {
      if (Get.context != null) {
        FocusScope.of(Get.context!).requestFocus(FocusNode());
      }
      Get.to(
        () => const NormalRequestLocationPage(),
        transition: getPageTransition(),
      );
    }
  }

  RequestInfoModel getRequestInfo() {
    final patientCondition = patientConditionTextController.text.trim();
    String bloodType = bloodTypeDropdownController.text.trim();
    bloodType = bloodType.isEmpty || bloodType == 'don\'tKnow'.tr
        ? 'unknown'
        : bloodType;
    String diabetic = diabetesDropdownController.text.trim();
    diabetic = diabetic.isEmpty || diabetic == 'don\'tKnow'.tr
        ? 'unknown'
        : diabetic == 'no'.tr
            ? Get.translations['en_US']!['no']!
            : diabetic;
    String hypertensive = hypertensiveDropdownController.text.trim();
    hypertensive = hypertensive.isEmpty || hypertensive == 'don\'tKnow'.tr
        ? 'unknown'
        : hypertensive == 'no'.tr
            ? Get.translations['en_US']!['no']!
            : Get.translations['en_US']!['yes']!;
    String heartPatient = heartPatientDropdownController.text.trim();
    heartPatient = heartPatient.isEmpty || heartPatient == 'don\'tKnow'.tr
        ? 'unknown'
        : heartPatient == 'no'.tr
            ? Get.translations['en_US']!['no']!
            : Get.translations['en_US']!['yes']!;
    String additionalInformation =
        additionalInformationTextController.text.trim();
    additionalInformation = additionalInformation.isEmpty
        ? 'No additional Information'
        : additionalInformation;
    return RequestInfoModel(
      isUser: userRequest.value,
      patientCondition: patientCondition,
      backupNumber: AuthenticationRepository.instance.userInfo.backupNumber,
      medicalHistory: userRequest.value
          ? null
          : MedicalHistoryModel(
              bloodType: bloodType,
              diabetic: diabetic,
              hypertensive: hypertensive,
              heartPatient: heartPatient,
              medicalAdditionalInfo: additionalInformation,
              diseasesList: diseasesList,
            ),
      sendSms: sendSms,
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

  void onSendSosSwitched(bool state) async {
    if (!AppInit.isWeb) {
      if (state) {
        if (await handleSmsPermission()) {
          sendSms = true;
        } else {
          sendSosPrimaryKey.currentState?.action();
        }
      } else {
        sendSms = false;
      }
    } else {
      sendSosPrimaryKey.currentState?.action();
      showSnackBar(
          text: 'useMobileToThisFeature'.tr, snackBarType: SnackBarType.info);
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
