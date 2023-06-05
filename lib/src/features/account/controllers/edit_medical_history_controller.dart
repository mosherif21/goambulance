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
  final hypertensiveDropdownController = TextEditingController();
  final diabetesDropdownController = TextEditingController();
  final heartPatientDropdownController = TextEditingController();
  final bloodTypeDropdownController = TextEditingController();

  //medical history
  var diseasesList = <DiseaseItem>[].obs;
  var currentDiseasesDocIds = <String>[];
  final highlightBloodType = false.obs;
  bool hypertensivePatient = false;
  bool heartPatient = false;
  final diseaseName = ''.obs;
  final hypertensiveKey = GlobalKey<RollingSwitchState>();
  final heartPatientKey = GlobalKey<RollingSwitchState>();

  late final String userId;
  late final UserInformation userInfo;
  late final AuthenticationRepository authRep;
  final diseasesLoaded = false.obs;
  @override
  void onInit() async {
    authRep = AuthenticationRepository.instance;
    userInfo = authRep.userInfo;
    userId = authRep.fireUser.value!.uid;
    loadDiseases();
    super.onInit();
  }

  @override
  void onReady() async {
    additionalInformationTextController.text = userInfo.additionalInformation;
    bloodTypeDropdownController.text = userInfo.bloodType;
    diabetesDropdownController.text =
        userInfo.diabetic == 'No' ? 'no'.tr : userInfo.diabetic;
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

  void loadDiseases() async {
    diseasesList.value = await FirebasePatientDataAccess.instance.getDiseases();
    diseasesLoaded.value = true;
  }

  Future<void> updateMedicalInfo() async {
    final bloodType = bloodTypeDropdownController.text.trim();
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
          updateUserData(bloodType: bloodType);
        },
        negativeButtonOnPressed: () => Get.back(),
        mainIcon: Icons.check_circle_outline,
        color: SweetSheetColor.NICE,
      );
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  void updateUserData({required String bloodType}) async {
    showLoadingScreen();
    String diabetic = diabetesDropdownController.text.trim();
    diabetic = diabetic.isEmpty || diabetic == 'no'.tr
        ? Get.translations['en_US']!['no']!
        : diabetic;
    final medicalHistoryData = MedicalHistoryModel(
      bloodType: bloodType,
      diabetic: diabetic,
      hypertensive: hypertensivePatient ? 'Yes' : 'No',
      heartPatient: heartPatient ? 'Yes' : 'No',
      additionalInformation: additionalInformationTextController.text.trim(),
      diseasesList: diseasesList,
    );
    final functionStatus =
        await FirebasePatientDataAccess.instance.updateMedicalHistory(
      medicalHistoryData: medicalHistoryData,
      currentDiseasesDocIds: currentDiseasesDocIds,
    );
    if (functionStatus == FunctionStatus.success) {
      authRep.userInfo.bloodType = medicalHistoryData.bloodType;
      authRep.userInfo.diabetic = medicalHistoryData.diabetic;
      authRep.userInfo.hypertensive = medicalHistoryData.hypertensive;
      authRep.userInfo.heartPatient = medicalHistoryData.heartPatient;
      authRep.userInfo.additionalInformation =
          medicalHistoryData.additionalInformation;
      if (authRep.criticalUserStatus.value !=
          CriticalUserStatus.criticalUserAccepted) {
        authRep.criticalUserStatus.value = CriticalUserStatus.non;
      }
      hideLoadingScreen();
      Get.back();
      showSnackBar(
          text: 'medicalHistorySavedSuccess'.tr,
          snackBarType: SnackBarType.success);
    } else {
      hideLoadingScreen();
      showSnackBar(
          text: 'medicalHistorySavedError'.tr,
          snackBarType: SnackBarType.error);
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
    hypertensiveDropdownController.dispose();
    diabetesDropdownController.dispose();
    heartPatientDropdownController.dispose();
    bloodTypeDropdownController.dispose();
    super.onClose();
  }
}
