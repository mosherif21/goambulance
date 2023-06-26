import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/enums.dart';
import '../../../../general/app_init.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';

class RegisterEmployeeDataController extends GetxController {
  static RegisterEmployeeDataController get instance => Get.find();

  //images
  final picker = ImagePicker();
  late Rx<XFile?> profileImage = Rx<XFile?>(null);
  late Rx<XFile?> iDImage = Rx<XFile?>(null);

  RxBool isProfileImageAdded = false.obs;
  RxBool isNationalIDImageAdded = false.obs;

  RxBool highlightProfilePic = false.obs;
  RxBool highlightNationalIdPick = false.obs;

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
    highlightProfilePic.value = !isProfileImageAdded.value;
    highlightNationalIdPick.value = !isNationalIDImageAdded.value;
    if (!highlightProfilePic.value && !highlightNationalIdPick.value) {
      showLoadingScreen();
      final functionStatus = await FirebaseAmbulanceEmployeeDataAccess.instance
          .saveUserInformation(
        profilePic: profileImage.value!,
        nationalID: iDImage.value!,
      );
      if (functionStatus == FunctionStatus.success) {
        AppInit.goToInitPage();
      } else {
        hideLoadingScreen();
        showSnackBar(
            text: 'saveUserInfoError'.tr, snackBarType: SnackBarType.error);
      }
    } else {
      showSnackBar(text: 'requiredFields'.tr, snackBarType: SnackBarType.error);
    }
  }
}
