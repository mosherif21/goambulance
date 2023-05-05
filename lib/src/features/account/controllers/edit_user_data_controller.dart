import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eg_nid/eg_nid.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../components/models.dart';

class EditUserDataController extends GetxController {
  static EditUserDataController get instance => Get.find();

  //vars
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
  bool makeButtonEditable = true;

  final hypertensiveKey = GlobalKey<RollingSwitchState>();

  late final String userId;
  late final User currentUser;
  late final UserInformation userInfo;

  late final AuthenticationRepository authRep;
  late final FirebaseStorage fireStorage;

  @override
  void onInit() {
    authRep = AuthenticationRepository.instance;
    fireStorage = FirebaseStorage.instance;
    currentUser = authRep.fireUser.value!;
    userInfo = authRep.userInfo;
    userId = currentUser.uid;
    loadImages();
    super.onInit();
  }

  @override
  void onReady() {
    if (currentUser.email != null) {
      emailTextController.text = currentUser.email!;
      makeEmailEditable = false;
    } else {
      emailTextController.text = userInfo.email;
    }
    nameTextController.text = userInfo.name;
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

    /* ana 5leto ya5od el value bs 3shan lw hwa 8yar el value bta3t el birthdate
     we el gender we etsayevo fe el database lama yeft7 el account details
     ma y7otelo4 el 7aga men el national id we hwa mo5tlef fe el database
    */
    nationalIdTextController.text = userInfo.nationalId;
    gender = userInfo.gender == 'male' ? Gender.male : Gender.female;
    genderRadioKey.currentState?.selectButton(gender!);
    final birthDate = userInfo.birthDate;
    birthDateController.displayDate = birthDate;
    birthDateController.selectedDate =
        DateTime(birthDate.year, birthDate.month, birthDate.day);
    super.onReady();
  }

  void loadImages() {
    final userStorageRef = fireStorage.ref().child('users/$userId');
    try {
      userStorageRef.child('profilePic').getData().then((imageData) {
        profileMemoryImage.value = MemoryImage(imageData!);
        isProfileImageLoaded.value = true;
      });
      userStorageRef.child('nationalId').getData().then((idData) {
        idMemoryImage.value = MemoryImage(idData!);
        isNationalIDImageLoaded.value = true;
      });
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
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
    final accountDetails = AccountDetailsModel(
      name: nameTextController.text.trim(),
      email: emailTextController.text.trim(),
      nationalId: nationalIdTextController.text.trim(),
      birthDate: birthDateController.selectedDate!,
      gender: gender == Gender.male ? 'male' : 'female',
    );
    final functionStatus =
        await FirebasePatientDataAccess.instance.updateUserDataInfo(
      profilePic: isProfileImageChanged.value ? profileImage.value : null,
      nationalID: isNationalIDImageChanged.value ? iDImage.value : null,
      accountDetails: accountDetails,
    );
    if (functionStatus == FunctionStatus.success) {
      isProfileImageChanged.value = false;
      isNationalIDImageChanged.value = false;
      authRep.userInfo.name = accountDetails.name;
      authRep.drawerAccountName.value = accountDetails.name;
      authRep.userInfo.email = accountDetails.email;
      authRep.userInfo.nationalId = accountDetails.nationalId;
      authRep.userInfo.birthDate = accountDetails.birthDate;
      authRep.userInfo.gender = accountDetails.gender;
      Get.back();
      hideLoadingScreen();
      showSnackBar(
          text: 'accountDetailSavedSuccess'.tr,
          snackBarType: SnackBarType.success);
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
