import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eg_nid/eg_nid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_access.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/account/components/newAccount/medical_history_insert_page.dart';
import 'package:goambulance/src/general/common_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../constants/app_init_constants.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../home_screen/screens/home_screen.dart';

enum Gender {
  male,
  female,
}

class RegisterUserDataController extends GetxController {
  static RegisterUserDataController get instance => Get.find();

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

  @override
  void onInit() {
    super.onInit();
    final user = AuthenticationRepository.instance.fireUser.value;
    final userEmail = user?.email ?? '';
    final userName = user?.displayName ?? '';
    nameTextController.text = userName;
    emailTextController.text = userEmail;
  }

  @override
  void onReady() {
    super.onReady();
    nameTextController.addListener(() {
      if (nameTextController.text.isNotEmpty) highlightName.value = false;
    });
    emailTextController.addListener(() {
      if (emailTextController.text.isEmail) highlightEmail.value = false;
    });
    nationalIdTextController.addListener(() {
      final nationalId = nationalIdTextController.text;
      if (NIDInfo.NIDCheck(nid: nationalId)) {
        try {
          final nationalIdData = NIDInfo(nid: nationalId);
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
    final addedImage = await picker.pickImage(source: ImageSource.camera);
    if (addedImage != null) {
      isProfileImageAdded.value = true;
      profileImage.value = addedImage;
      highlightProfilePic.value = false;
    }
  }

  Future<void> captureIDPic() async {
    RegularBottomSheet.hideBottomSheet();
    final addedImage = await picker.pickImage(source: ImageSource.camera);
    if (addedImage != null) {
      isNationalIDImageAdded.value = true;

      iDImage.value = addedImage;
      highlightNationalIdPick.value = false;
    }
  }


  Future<void> checkPersonalInformation() async {
    final name = nameTextController.text;
    final email = emailTextController.text;
    final nationalId = nationalIdTextController.text;

    highlightName.value = name.isEmpty ? true : false;
    highlightEmail.value = email.isEmail ? false : true;

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
    highlightGender.value = gender == null ? true : false;
    highlightBirthdate.value =
        birthDateController.selectedDate == null ? true : false;
    highlightProfilePic.value = isProfileImageAdded.value ? false : true;
    highlightNationalIdPick.value = isNationalIDImageAdded.value ? false : true;
    if (!highlightName.value &&
        !highlightEmail.value &&
        !highlightNationalId.value &&
        !highlightGender.value &&
        !highlightBirthdate.value &&
        !highlightProfilePic.value &&
        !highlightNationalIdPick.value) {
      Get.to(() => const MedicalHistoryInsertPage(),
          transition: AppInit.getPageTransition());
    } else {
      showSimpleSnackBar(text: 'requiredFields'.tr);
    }
  }

  Future<void> savePersonalInformation() async {
    showLoadingScreen();
    final name = nameTextController.text;
    final email = emailTextController.text;
    final nationalId = nationalIdTextController.text;
    final birthDate = birthDateController.selectedDate;
    final userInfo = UserInfoSave(
      name: name,
      email: email,
      nationalId: nationalId,
      birthDate: birthDate!,
      gender: gender == Gender.male ? 'male' : 'female',
    );

    final functionStatus = await FirebaseDataAccess.instance
        .saveUserPersonalInformation(
            userInfo: userInfo,
            profilePic: profileImage.value!,
            nationalID: iDImage.value!);
    if (functionStatus == FunctionStatus.success) {
      hideLoadingScreen();
      Get.offAll(() => const HomeScreen(),
          transition: AppInit.getPageTransition());
    } else {
      showSimpleSnackBar(text: 'saveUserInfoError'.tr);
      hideLoadingScreen();
    }
  }
}
