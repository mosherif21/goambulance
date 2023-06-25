import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:rolling_switch/rolling_switch.dart';

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
  late final AuthenticationRepository authRep;
  final diseasesLoaded = false.obs;
  @override
  void onInit() {
    authRep = AuthenticationRepository.instance;
    userId = authRep.fireUser.value!.uid;
    super.onInit();
  }

  @override
  void onReady() async {
    final medicalInfo =
        await FirebasePatientDataAccess.instance.getMedicalHistory();
    if (medicalInfo != null) {
      diseasesList.value = medicalInfo.diseasesList;
      diseasesLoaded.value = true;
      if (medicalInfo.currentDiseasesDocIds != null) {
        currentDiseasesDocIds = medicalInfo.currentDiseasesDocIds!;
      }
      additionalInformationTextController.text =
          medicalInfo.medicalAdditionalInfo;
      bloodTypeDropdownController.text = medicalInfo.bloodType;
      diabetesDropdownController.text =
          medicalInfo.diabetic == 'No' ? 'no'.tr : medicalInfo.diabetic;
      if (medicalInfo.hypertensive == 'No') {
        hypertensivePatient = false;
      } else if (medicalInfo.hypertensive == 'Yes') {
        hypertensivePatient = true;
        hypertensiveKey.currentState?.action();
      }
      if (medicalInfo.heartPatient == 'No') {
        heartPatient = false;
      } else {
        heartPatient = true;
        heartPatientKey.currentState?.action();
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
    }
    super.onReady();
  }

  Future<void> updateMedicalInfo() async {
    final bloodType = bloodTypeDropdownController.text.trim();
    highlightBloodType.value =
        bloodType.compareTo('pickBloodType'.tr) == 0 || bloodType.isEmpty;
    if (!highlightBloodType.value) {
      updateUserData(bloodType: bloodType);
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
      medicalAdditionalInfo: additionalInformationTextController.text.trim(),
      diseasesList: diseasesList,
      currentDiseasesDocIds: currentDiseasesDocIds,
    );
    final functionStatus =
        await FirebasePatientDataAccess.instance.updateMedicalHistory(
      medicalHistoryData: medicalHistoryData,
    );
    if (functionStatus == FunctionStatus.success) {
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
