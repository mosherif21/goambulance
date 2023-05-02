import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eg_nid/eg_nid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../../firebase_files/firebase_patient_access.dart';
import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';

class EditUserDataController extends GetxController {
  static EditUserDataController get instance => Get.find();

  //vars
  late final String phoneNumber;
  late final String oldName;
  late final String oldEmail;
  late final String oldNationalId;
  late final DateTime oldBirthDate;

  //controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final nationalIdTextController = TextEditingController();
  final birthDateController = DateRangePickerController();

  //gender
  Gender? gender;
  final genderRadioKey = GlobalKey<CustomRadioButtonState<Gender>>();

  //images
  final picker = ImagePicker();
  late Rx<XFile?> profileImage = Rx<XFile?>(null);
  late Rx<XFile?> iDImage = Rx<XFile?>(null);
  late Rx<ImageProvider?> idMemoryImage = Rx<ImageProvider?>(null);
  late Rx<ImageProvider?> profileMemoryImage = Rx<ImageProvider?>(null);

  final isProfileImageChanged = false.obs;
  final isNationalIDImageChanged = false.obs;

  final isNationalIDImageLoaded = false.obs;
  final isProfileImageLoaded = false.obs;

  final highlightName = false.obs;
  final highlightEmail = false.obs;
  final highlightNationalId = false.obs;
  bool makeEmailEditable = true;

  final user = AuthenticationRepository.instance.fireUser.value;
  final hypertensiveKey = GlobalKey<RollingSwitchState>();

  late final String userId;
  final fireStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    userId = user!.uid;
    if (user?.email != null) {
      emailTextController.text = user!.email!;
      makeEmailEditable = false;
    }
    final userName = user?.displayName ?? '';
    nameTextController.text = userName;
    phoneNumber = user!.phoneNumber!;
    nationalIdTextController.text =
        AuthenticationRepository.instance.userInfo!.nationalId;
    loadImages();

    super.onInit();
  }

  void loadImages() {
    final userStorageRef = fireStorage.ref().child('users/$userId');
    final storageIdRef = userStorageRef.child('nationalId');
    final storageProfileRef = userStorageRef.child('profilePic');
    try {
      storageProfileRef.getData().then((imageData) {
        profileMemoryImage.value = MemoryImage(imageData!);
        isProfileImageLoaded.value = true;
      });
      storageIdRef.getData().then((idData) {
        idMemoryImage.value = MemoryImage(idData!);
        isNationalIDImageLoaded.value = true;
      });
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  /*hatst5dm variable el userinfo ely fe el authentication repository  yet3rad beh el info el adema we b3d ma ye update kol el data aw myupdat4 we ydos
   save ht update el data fe firestore we te update variable userInfo be el data el gdeda */
  @override
  void onReady() {
    nameTextController.addListener(() {
      if (nameTextController.text.trim().isNotEmpty) {
        highlightName.value = false;
      }
    });

    emailTextController.addListener(() {
      if (emailTextController.text.trim().isEmail) {
        highlightEmail.value = false;
      }
    });
    final nationalId = nationalIdTextController.text;
    if (NIDInfo.NIDCheck(nid: nationalId)) {
      try {
        final nationalIdData = NIDInfo(nid: nationalId);
        FocusManager.instance.primaryFocus?.unfocus();
        gender =
            nationalIdData.sex.contains('Male') ? Gender.male : Gender.female;
        genderRadioKey.currentState?.selectButton(gender!);
        final birthDate = nationalIdData.birthDay;
        birthDateController.displayDate = birthDate;
        birthDateController.selectedDate =
            DateTime(birthDate.year, birthDate.month, birthDate.day);
        highlightNationalId.value = false;
        FocusManager.instance.primaryFocus?.unfocus();
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
    }
    super.onReady();
  }

  Future<void> pickProfilePic() async {
    RegularBottomSheet.hideBottomSheet();
    final addedImage = await picker.pickImage(source: ImageSource.gallery);
    if (addedImage != null) {
      profileImage.value = addedImage;
      isProfileImageChanged.value = true;
    }
  }

  Future<void> pickIdPic() async {
    RegularBottomSheet.hideBottomSheet();
    final addedIdImage = await picker.pickImage(source: ImageSource.gallery);
    if (addedIdImage != null) {
      iDImage.value = addedIdImage;
      isNationalIDImageChanged.value = true;
    }
  }

  Future<void> captureProfilePic() async {
    RegularBottomSheet.hideBottomSheet();
    if (await handleCameraPermission()) {
      final addedImage = await picker.pickImage(source: ImageSource.camera);
      if (addedImage != null) {
        profileImage.value = addedImage;
        isProfileImageChanged.value = true;
      }
    }
  }

  Future<void> captureIDPic() async {
    RegularBottomSheet.hideBottomSheet();
    if (await handleCameraPermission()) {
      final addedIdImage = await picker.pickImage(source: ImageSource.camera);
      if (addedIdImage != null) {
        iDImage.value = addedIdImage;
        isNationalIDImageChanged.value = true;
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
    if (!highlightName.value &&
        !highlightEmail.value &&
        !highlightNationalId.value) {
      savePersonalInformation();
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }

  Future<void> savePersonalInformation() async {
    displayAlertDialog(
      title: 'confirm'.tr,
      body: 'personalInfoShare'.tr,
      positiveButtonText: 'agree'.tr,
      negativeButtonText: 'disagree'.tr,
      positiveButtonOnPressed: () {
        Get.back();
        updateUserInfoData();
      },
      negativeButtonOnPressed: () => Get.back(),
      mainIcon: Icons.check_circle_outline,
      color: SweetSheetColor.NICE,
    );
  }

  void updateUserInfoData() async {
    showLoadingScreen();
    final name = nameTextController.text.trim();
    final email = emailTextController.text.trim();
    final nationalId = nationalIdTextController.text.trim();
    final birthDate = birthDateController.selectedDate;
    final functionStatus =
        await FirebasePatientDataAccess.instance.updateUserDataInfo(
      profilePic: isProfileImageChanged.value ? profileImage.value : null,
      nationalID: isNationalIDImageChanged.value ? iDImage.value : null,
      name: name,
      email: email,
      nationalId: nationalId,
      gender: gender == Gender.male ? 'male' : 'female',
      birthdate: birthDate,
    );
    AuthenticationRepository.instance.drawerProfileImageUrl.value =
        await fireStorage
            .ref()
            .child('users/$userId')
            .child('profilePic')
            .getDownloadURL();
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
    nameTextController.dispose();
    emailTextController.dispose();
    phoneTextController.dispose();
    nationalIdTextController.dispose();
    birthDateController.dispose();
    super.onClose();
  }
}
