import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eg_nid/eg_nid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/account/components/new_account/medical_history_insert_page.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../../firebase_files/firebase_patient_access.dart';
import '../../../constants/enums.dart';
import '../../../general/app_init.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';

class RegisterUserDataController extends GetxController {
  static RegisterUserDataController get instance => Get.find();
  //controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final nationalIdTextController = TextEditingController();
  final birthDateController = DateRangePickerController();
  final diseaseNameTextController = TextEditingController();
  final medicinesTextController = TextEditingController();
  final medicalHistoryScrollController = ScrollController();
  final additionalInformationTextController = TextEditingController();

  //gender
  Gender? gender;
  final genderRadioKey = GlobalKey<CustomRadioButtonState<Gender>>();

  //images
  final picker = ImagePicker();
  late Rx<XFile?> profileImage = Rx<XFile?>(null);
  late Rx<XFile?> iDImage = Rx<XFile?>(null);

  RxBool isProfileImageAdded = false.obs;
  RxBool isNationalIDImageAdded = false.obs;

  RxBool highlightName = false.obs;
  RxBool highlightEmail = false.obs;
  RxBool highlightNationalId = false.obs;
  RxBool highlightGender = false.obs;
  RxBool highlightBirthdate = false.obs;
  RxBool highlightProfilePic = false.obs;
  RxBool highlightNationalIdPick = false.obs;
  String backupPhoneNo = '';
  //medical history
  var diseasesList = <DiseaseItem>[].obs;
  RxBool highlightBloodType = false.obs;
  bool hypertensivePatient = false;
  bool heartPatient = false;
  final diseaseName = ''.obs;

  final diabetesDropdownController = TextEditingController();

  final bloodTypeDropdownController = TextEditingController();
  late final User user;
  late final AuthenticationRepository authRep;
  @override
  void onInit() {
    authRep = AuthenticationRepository.instance;
    user = authRep.fireUser.value!;

    final userName = user.displayName ?? '';
    nameTextController.text = userName;
    super.onInit();
  }

  @override
  void onReady() {
    nameTextController.addListener(() {
      if (nameTextController.text.trim().isNotEmpty) {
        highlightName.value = false;
      }
    });
    bloodTypeDropdownController.addListener(() {
      final bloodTypeValue = bloodTypeDropdownController.text.trim();
      if (bloodTypeValue.isNotEmpty || bloodTypeValue != 'pickBloodType'.tr) {
        highlightBloodType.value = false;
      }
    });
    emailTextController.addListener(() {
      if (emailTextController.text.trim().isEmail) {
        highlightEmail.value = false;
      }
    });
    diseaseNameTextController.addListener(() {
      diseaseName.value = diseaseNameTextController.text.trim();
    });
    nationalIdTextController.addListener(() {
      final nationalId = nationalIdTextController.text;
      if (NIDInfo.NIDCheck(nid: nationalId)) {
        try {
          final nationalIdData = NIDInfo(nid: nationalId);
          FocusManager.instance.primaryFocus?.unfocus();
          gender = nationalIdData.sex == 'Male' ? Gender.male : Gender.female;
          genderRadioKey.currentState?.selectButton(gender!);
          final birthDate = nationalIdData.birthDay;
          birthDateController.displayDate = birthDate;
          birthDateController.selectedDate =
              DateTime(birthDate.year, birthDate.month, birthDate.day);
          highlightNationalId.value = false;
          highlightGender.value = false;
          highlightBirthdate.value = false;
          FocusManager.instance.primaryFocus?.unfocus();
        } catch (e) {
          if (kDebugMode) {
            AppInit.logger.e(e.toString());
          }
        }
      }
    });
    super.onReady();
  }

  Future<void> pickProfilePic() async {
    RegularBottomSheet.hideBottomSheet();
    final addedImage = await picker.pickImage(source: ImageSource.gallery);
    if (addedImage != null) {
      isProfileImageAdded.value = true;
      profileImage.value = addedImage;
      highlightProfilePic.value = false;
    }
  }

  Future<void> pickIdPic() async {
    RegularBottomSheet.hideBottomSheet();
    final addedImage = await picker.pickImage(source: ImageSource.gallery);
    if (addedImage != null) {
      isNationalIDImageAdded.value = true;
      iDImage.value = addedImage;
      highlightNationalIdPick.value = false;
    }
  }

  Future<void> captureProfilePic() async {
    RegularBottomSheet.hideBottomSheet();
    if (await handleCameraPermission()) {
      final addedImage = await picker.pickImage(source: ImageSource.camera);
      if (addedImage != null) {
        isProfileImageAdded.value = true;
        profileImage.value = addedImage;
        highlightProfilePic.value = false;
      }
    }
  }

  Future<void> captureIDPic() async {
    RegularBottomSheet.hideBottomSheet();
    if (await handleCameraPermission()) {
      final addedImage = await picker.pickImage(source: ImageSource.camera);
      if (addedImage != null) {
        isNationalIDImageAdded.value = true;
        iDImage.value = addedImage;
        highlightNationalIdPick.value = false;
      }
    }
  }

  Future<void> checkPersonalInformation() async {
    highlightName.value = nameTextController.text.trim().isEmpty;
    highlightEmail.value = !emailTextController.text.trim().isEmail;
    final nationalId = nationalIdTextController.text.trim();

    if (NIDInfo.NIDCheck(nid: nationalId)) {
      try {
        NIDInfo(nid: nationalId);
        highlightNationalId.value = false;
      } catch (e) {
        if (kDebugMode) {
          AppInit.logger.e(e.toString());
        }
        highlightNationalId.value = true;
      }
    } else {
      highlightNationalId.value = true;
    }
    highlightGender.value = gender == null;
    highlightBirthdate.value = birthDateController.selectedDate == null;
    highlightProfilePic.value = !isProfileImageAdded.value;
    highlightNationalIdPick.value = !isNationalIDImageAdded.value;
    if (!highlightName.value &&
        !highlightEmail.value &&
        !highlightNationalId.value &&
        !highlightGender.value &&
        !highlightBirthdate.value &&
        !highlightProfilePic.value &&
        !highlightNationalIdPick.value) {
      Get.to(
        () => const MedicalHistoryInsertPage(),
        transition: getPageTransition(),
      );
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  Future<void> savePersonalInformation() async {
    final bloodType = bloodTypeDropdownController.text.trim();
    highlightBloodType.value =
        bloodType == 'pickBloodType'.tr || bloodType.isEmpty;
    if (!highlightBloodType.value) {
      displayAlertDialog(
        title: 'confirm'.tr,
        body: 'personalInfoShare'.tr,
        positiveButtonText: 'agree'.tr,
        negativeButtonText: 'disagree'.tr,
        positiveButtonOnPressed: () => registerUserData(bloodType: bloodType),
        negativeButtonOnPressed: () => Get.back(),
        mainIcon: Icons.check_circle_outline,
        color: SweetSheetColor.NICE,
      );
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  void registerUserData({required String bloodType}) async {
    Get.back();
    showLoadingScreen();
    String diabetic = diabetesDropdownController.text.trim();
    diabetic = diabetic.isEmpty || diabetic == 'no'.tr
        ? Get.translations['en_US']!['no']!
        : diabetic;
    final name = nameTextController.text.trim();
    final email = emailTextController.text.trim();
    final nationalId = nationalIdTextController.text.trim();
    final birthDate = birthDateController.selectedDate;
    final phone = user.phoneNumber!;
    final returnMessage =
        await authRep.updateUserEmailAuthentication(email: email);
    if (returnMessage != 'success') {
      hideLoadingScreen();
      showSnackBar(text: returnMessage, snackBarType: SnackBarType.error);
    } else {
      final userInfo = UserInformation(
        name: name,
        email: email,
        nationalId: nationalId,
        birthDate: birthDate!,
        gender: gender == Gender.male ? 'male' : 'female',
        sosMessage: '',
        criticalUser: false,
        phone: phone,
        backupNumber: backupPhoneNo.length == 13 ? backupPhoneNo : 'unknown',
      );

      final medicalHistoryModel = MedicalHistoryModel(
        bloodType: bloodType,
        diabetic: diabetic,
        hypertensive: hypertensivePatient ? 'Yes' : 'No',
        heartPatient: heartPatient ? 'Yes' : 'No',
        medicalAdditionalInfo: additionalInformationTextController.text.trim(),
        diseasesList: diseasesList,
      );

      final functionStatus =
          await FirebasePatientDataAccess.instance.saveUserPersonalInformation(
        userRegisterInfo: userInfo,
        medicalHistoryModel: medicalHistoryModel,
        profilePic: profileImage.value!,
        nationalID: iDImage.value!,
      );
      if (functionStatus == FunctionStatus.success) {
        await user.updateDisplayName(name);
        AppInit.goToInitPage();
      } else {
        hideLoadingScreen();
        showSnackBar(
            text: 'saveUserInfoError'.tr, snackBarType: SnackBarType.error);
      }
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
    nameTextController.dispose();
    emailTextController.dispose();
    phoneTextController.dispose();
    nationalIdTextController.dispose();
    birthDateController.dispose();
    diseaseNameTextController.dispose();
    medicinesTextController.dispose();
    medicalHistoryScrollController.dispose();
    additionalInformationTextController.dispose();
    super.onClose();
  }
}
