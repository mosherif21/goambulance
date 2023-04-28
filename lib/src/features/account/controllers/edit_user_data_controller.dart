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

class EditUserDataController extends GetxController {
  static EditUserDataController get instance => Get.find();

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

  final isProfileImageAdded = false.obs;
  final isNationalIDImageAdded = false.obs;

  final highlightName = false.obs;
  final highlightEmail = false.obs;
  final highlightNationalId = false.obs;
  final highlightGender = false.obs;
  final highlightBirthdate = false.obs;
  final highlightProfilePic = false.obs;
  final highlightNationalIdPick = false.obs;

  bool makeEmailEditable = true;

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
  @override
  void onInit() {
    super.onInit();

    if (user?.email != null) {
      emailTextController.text = user!.email!;
      makeEmailEditable = false;
    }
    final userName = user?.displayName ?? '';
    nameTextController.text = userName;
    phoneNumber = user!.phoneNumber!;
  }

  /*hatst5dm variable el userinfo ely fe el authentication repository  yet3rad beh el info el adema we b3d ma ye update kol el data aw myupdat4 we ydos
   save ht update el data fe firestore we te update variable userInfo be el data el gdeda */
  @override
  void onReady() async {
    super.onReady();
    final userId = AuthenticationRepository.instance.fireUser.value!.uid;
    final storageRef =
        FirebaseStorage.instance.ref().child('users/$userId/profilePic');
    var imageData = await storageRef.getData();
    XFile imageFile = XFile.fromData(imageData!);
    profileImage.value = imageFile;
    isProfileImageAdded.value = true;
    final firestoreInstance = FirebaseFirestore.instance;
    final documentReference = firestoreInstance.collection("users").doc(userId);

    documentReference.get().then((documentSnapshot) {
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
    });

    nameTextController.addListener(() {
      if (nameTextController.text.trim().isNotEmpty) {
        highlightName.value = false;
      }
    });
    bloodTypeDropdownController.addListener(() {
      final bloodTypeValue = bloodTypeDropdownController.text.trim();
      if (bloodTypeValue.isNotEmpty ||
          bloodTypeValue.compareTo('pickBloodType'.tr) != 0) {
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
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
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
        positiveButtonOnPressed: () =>
            registerUserData(bloodType: bloodType, diabetic: diabetic),
        negativeButtonOnPressed: () => Get.back(),
        mainIcon: Icons.check_circle_outline,
        color: SweetSheetColor.NICE,
      );
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  void registerUserData(
      {required String bloodType, required String diabetic}) async {
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
      additionalInformation: additionalInformationTextController.text.trim(),
      phoneNumber: phoneNumber,
      sosMessage: '',
      criticalUser: false,
    );

    final functionStatus =
        await FirebasePatientDataAccess.instance.saveUserPersonalInformation(
      userRegisterInfo: userInfo,
      profilePic: profileImage.value!,
      nationalID: iDImage.value!,
      diseasesList: diseasesList,
    );
    if (functionStatus == FunctionStatus.success) {
      hideLoadingScreen();
      AppInit.goToInitPage();
    } else {
      hideLoadingScreen();
      showSnackBar(
          text: 'saveUserInfoError'.tr, snackBarType: SnackBarType.error);
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
