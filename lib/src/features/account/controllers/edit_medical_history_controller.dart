import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eg_nid/eg_nid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/account/components/newAccount/medical_history_insert_page.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../../firebase_files/firebase_patient_access.dart';
import '../../../constants/app_init_constants.dart';
import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';

class EditMedicalHistoryController extends GetxController {
  static EditMedicalHistoryController get instance => Get.find();

  //vars
  late final String phoneNumber;

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
  final user = AuthenticationRepository.instance.fireUser.value;
  final hypertensiveKey = GlobalKey<RollingSwitchState>();
  final heartPatientKey = GlobalKey<RollingSwitchState>();

  /*hatst5dm variable el userinfo ely fe el authentication repository  yet3rad beh el info el adema we b3d ma ye update kol el data aw myupdat4 we ydos
   save ht update el data fe firestore we te update variable userInfo be el data el gdeda */
  @override
  void onReady() async {
    super.onReady();


    bloodTypeDropdownController.text =AuthenticationRepository.instance.userInfo!.bloodType;
    diabetesDropdownController.text =AuthenticationRepository.instance.userInfo!.diabetesPatient;

    if (AuthenticationRepository.instance.userInfo!.hypertensive== 'No') {
      hypertensivePatient = false;
    } else if (AuthenticationRepository.instance.userInfo!.hypertensive == 'Yes') {
      hypertensivePatient = true;
      hypertensiveKey.currentState!.action();
    }
    if (AuthenticationRepository.instance.userInfo!.heartPatient == 'No') {
      heartPatient = false;
    } else {
      heartPatient = true;
      heartPatientKey.currentState!.action();
    }
   /* documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        bloodTypeDropdownController.text =
            documentSnapshot.get('bloodType').toString();
        diabetesDropdownController.text =
            documentSnapshot.get('diabetic').toString();
        if (documentSnapshot.get('hypertensive').toString() == 'No') {
          hypertensivePatient = false;
        } else if (documentSnapshot.get('hypertensive').toString() == 'Yes') {
          hypertensivePatient = true;
          hypertensiveKey.currentState!.action();
        }
        if (documentSnapshot.get('heartPatient').toString() == 'No') {
          heartPatient = false;
        } else {
          heartPatient = true;
        }
      } else {
        if (kDebugMode) {
          print('Document does not exist on the database');
        }
      }
    }*/


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
        positiveButtonOnPressed: () =>
            updateUserData(bloodType: bloodType, diabetic: diabetic),
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
    Get.back();
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

  @override
  void onClose() {
    diseaseNameTextController.dispose();
    medicinesTextController.dispose();
    medicalHistoryScrollController.dispose();
    additionalInformationTextController.dispose();
    super.onClose();
  }
}
