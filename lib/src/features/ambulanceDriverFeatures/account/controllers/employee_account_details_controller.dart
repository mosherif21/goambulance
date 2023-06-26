import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rolling_switch/rolling_switch.dart';

import '../../../../../authentication/authentication_repository.dart';
import '../../../../constants/enums.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../account/components/models.dart';

class EmployeeUserDataController extends GetxController {
  static EmployeeUserDataController get instance => Get.find();

  //vars
  late final String oldName;
  late final String oldEmail;
  late final String oldNationalId;

  //controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final nationalIdTextController = TextEditingController();

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

  final verificationSent = false.obs;

  final hypertensiveKey = GlobalKey<RollingSwitchState>();

  late final String userId;
  late final User currentUser;
  late final EmployeeUserInformation userInfo;

  late final AuthenticationRepository authRep;
  late final FirebaseStorage fireStorage;

  void verifyEmail() async {
    showLoadingScreen();
    final functionStatus = await authRep.sendVerificationEmail();
    hideLoadingScreen();
    if (functionStatus == FunctionStatus.success) {
      showSnackBar(
          text: 'verifyEmailSent'.tr, snackBarType: SnackBarType.success);
      verificationSent.value = true;
    } else {
      showSnackBar(
          text: 'verifyEmailSendFailed'.tr, snackBarType: SnackBarType.error);
    }
  }

  @override
  void onInit() {
    authRep = AuthenticationRepository.instance;
    fireStorage = FirebaseStorage.instance;
    currentUser = authRep.fireUser.value!;
    userInfo = authRep.employeeUserInfo;
    userId = currentUser.uid;
    loadImages();
    super.onInit();
  }

  @override
  void onReady() {
    emailTextController.text = userInfo.email;
    nameTextController.text = userInfo.name;
    nationalIdTextController.text = userInfo.nationalId;
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

  void updateUserInfoData() async {
    showLoadingScreen();
    final functionStatus =
        await FirebaseAmbulanceEmployeeDataAccess.instance.updateUserInfo(
      profilePic: isProfileImageChanged.value ? profileImage.value : null,
      nationalID: isNationalIDImageChanged.value ? iDImage.value : null,
    );
    if (functionStatus == FunctionStatus.success) {
      isProfileImageChanged.value = false;
      isNationalIDImageChanged.value = false;
      hideLoadingScreen();
      Get.back();
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
    super.onClose();
  }
}
