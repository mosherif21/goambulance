import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../../firebase_files/firebase_patient_access.dart';
import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';

class EditMedicalHistoryController extends GetxController {
  static EditMedicalHistoryController get instance => Get.find();

  //controllers
  final diseaseNameTextController = TextEditingController();
  final medicinesTextController = TextEditingController();
  final medicalHistoryScrollController = ScrollController();
  final additionalInformationTextController = TextEditingController();

  //medical history
  var diseasesList = <DiseaseItem>[].obs;
  final highlightBloodType = false.obs;
  bool hypertensivePatient = false;
  bool heartPatient = false;
  final diseaseName = ''.obs;
  final hypertensiveDropdownController = TextEditingController();

  final diabetesDropdownController = TextEditingController();

  final heartPatientDropdownController = TextEditingController();

  final bloodTypeDropdownController = TextEditingController();
  final hypertensiveKey = GlobalKey<RollingSwitchState>();
  final heartPatientKey = GlobalKey<RollingSwitchState>();

  late final String userId;
  late final User currentUser;
  late final UserInformation userInfo;
  late final AuthenticationRepository authRep;

  @override
  void onInit() async {
    authRep = AuthenticationRepository.instance;
    currentUser = authRep.fireUser.value!;
    userInfo = authRep.userInfo!;
    userId = currentUser.uid;
    super.onInit();
  }

  @override
  void onReady() async {
    bloodTypeDropdownController.text = userInfo.bloodType;
    diabetesDropdownController.text = userInfo.diabetesPatient;
    if (userInfo.hypertensive == 'No') {
      hypertensivePatient = false;
    } else if (userInfo.hypertensive == 'Yes') {
      hypertensivePatient = true;
      hypertensiveKey.currentState!.action();
    }
    if (userInfo.heartPatient == 'No') {
      heartPatient = false;
    } else {
      heartPatient = true;
      heartPatientKey.currentState!.action();
    }
    bloodTypeDropdownController.addListener(() {
      final bloodTypeValue = bloodTypeDropdownController.text.trim();
      if (bloodTypeValue.isNotEmpty ||
          bloodTypeValue.compareTo('pickBloodType'.tr) != 0) {
        highlightBloodType.value = false;
      }
    });

    diseaseNameTextController.addListener(() {
      diseaseName.value = diseaseNameTextController.text.trim();
    });
    super.onReady();
  }

  Future<void> updateMedicalInfo() async {
    final bloodType = bloodTypeDropdownController.text;
    final diabetic = diabetesDropdownController.text.isEmpty
        ? 'no'.tr
        : diabetesDropdownController.text;
    highlightBloodType.value =
        bloodType.compareTo('pickBloodType'.tr) == 0 || bloodType.isEmpty;
    if (!highlightBloodType.value) {
      displayAlertDialog(
        title: 'confirm'.tr,
        body: 'personalInfoShare'.tr,
        positiveButtonText: 'agree'.tr,
        negativeButtonText: 'disagree'.tr,
        positiveButtonOnPressed: () {
          Get.back();
          updateUserData(bloodType: bloodType, diabetic: diabetic);
        },
        negativeButtonOnPressed: () => Get.back(),
        mainIcon: Icons.check_circle_outline,
        color: SweetSheetColor.NICE,
      );
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  void updateUserData(
      {required String bloodType, required String diabetic}) async {
    showLoadingScreen();
    final functionStatus =
        await FirebasePatientDataAccess.instance.updateMedicalHistory(
      diabetesPatient: diabetic,
      bloodType: bloodType,
      hypertensive: hypertensivePatient ? 'Yes' : 'No',
      heartPatient: heartPatient ? 'Yes' : 'No',
      diseasesList: diseasesList,
      additionalInformation: additionalInformationTextController.text.trim(),
    );
    if (functionStatus == FunctionStatus.success) {
      hideLoadingScreen();
    } else {
      hideLoadingScreen();
      showSnackBar(
          text: 'saveUserInfoError'.tr, snackBarType: SnackBarType.error);
    }
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
    medicalHistoryScrollController.dispose();
    additionalInformationTextController.dispose();
    super.onClose();
  }
}
