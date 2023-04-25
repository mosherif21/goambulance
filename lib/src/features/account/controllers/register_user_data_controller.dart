import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eg_nid/eg_nid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/account/components/newAccount/medical_history_insert_page.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../../firebase_files/firebase_patient_access.dart';
import '../../../constants/app_init_constants.dart';
import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';

class RegisterUserDataController extends GetxController {
  static RegisterUserDataController get instance => Get.find();
  //vars
  late final String phoneNumber;
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
  late Rx<XFile?> profileImage = XFile('').obs;
  late Rx<XFile?> iDImage = XFile('').obs;

  RxBool isProfileImageAdded = false.obs;
  RxBool isNationalIDImageAdded = false.obs;

  RxBool highlightName = false.obs;
  RxBool highlightEmail = false.obs;
  RxBool highlightNationalId = false.obs;
  RxBool highlightGender = false.obs;
  RxBool highlightBirthdate = false.obs;
  RxBool highlightProfilePic = false.obs;
  RxBool highlightNationalIdPick = false.obs;

  bool makeEmailEditable = true;

  //medical history
  var diseasesList = <DiseaseItem>[].obs;
  RxBool highlightBloodType = false.obs;
  bool hypertensivePatient = false;
  bool heartPatient = false;

  final hypertensiveDropdownController = TextEditingController();

  final diabetesDropdownController = TextEditingController();

  final heartPatientDropdownController = TextEditingController();

  final bloodTypeDropdownController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final user = AuthenticationRepository.instance.fireUser.value;
    if (user?.email != null) {
      emailTextController.text = user!.email!;
      makeEmailEditable = false;
    }
    final userName = user?.displayName ?? '';
    nameTextController.text = userName;
    phoneNumber = user!.phoneNumber!;
  }

  @override
  void onReady() {
    super.onReady();
    nameTextController.addListener(() {
      highlightName.value = nameTextController.text.trim().isEmpty;
    });
    bloodTypeDropdownController.addListener(() {
      final bloodTypeValue = bloodTypeDropdownController.text.trim();
      highlightBloodType.value = bloodTypeValue.isEmpty ||
          bloodTypeValue.compareTo('pickBloodType'.tr) == 0;
    });
    emailTextController.addListener(() {
      highlightEmail.value = !emailTextController.text.trim().isEmail;
    });
    nationalIdTextController.addListener(() {
      final nationalId = nationalIdTextController.text;
      if (NIDInfo.NIDCheck(nid: nationalId)) {
        try {
          final nationalIdData = NIDInfo(nid: nationalId);
          FocusManager.instance.primaryFocus?.unfocus();
          gender = nationalIdData.sex.compareTo('Male') == 0
              ? Gender.male
              : Gender.female;
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
          if (kDebugMode) print(e.toString());
        }
      }
    });
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
        if (kDebugMode) print(e.toString());
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
      showSimpleSnackBar(
          text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  Future<void> savePersonalInformation() async {
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
        positiveButtonOnPressed: () async {
          Get.back();
          showLoadingScreen();
          final name = nameTextController.text.trim();
          final email = emailTextController.text.trim();
          final nationalId = nationalIdTextController.text.trim();
          final birthDate = birthDateController.selectedDate;
          final userInfo = UserInformation(
            name: name,
            email: email,
            nationalId: nationalId,
            birthDate: birthDate!,
            gender: gender == Gender.male ? 'male' : 'female',
            bloodType: bloodType,
            diabetesPatient: diabetic,
            hypertensive: hypertensivePatient ? 'Yes' : 'No',
            heartPatient: heartPatient ? 'Yes' : 'No',
            additionalInformation:
                additionalInformationTextController.text.trim(),
            diseasesList: diseasesList,
            phoneNumber: phoneNumber,
          );

          final functionStatus = await FirebasePatientDataAccess.instance
              .saveUserPersonalInformation(
            userRegisterInfo: userInfo,
            profilePic: profileImage.value!,
            nationalID: iDImage.value!,
          );
          if (functionStatus == FunctionStatus.success) {
            hideLoadingScreen();
            AppInit.goToInitPage();
          } else {
            hideLoadingScreen();
            showSimpleSnackBar(
                text: 'saveUserInfoError'.tr, snackBarType: SnackBarType.error);
          }
        },
        negativeButtonOnPressed: () => Get.back(),
        mainIcon: Icons.check_circle_outline,
        color: SweetSheetColor.NICE,
      );
    } else {
      showSimpleSnackBar(
          text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
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
