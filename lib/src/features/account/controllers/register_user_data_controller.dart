import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:eg_nid/eg_nid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/newAccount/medical_history_insert_page.dart';
import 'package:goambulance/src/general/common_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../constants/app_init_constants.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';

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
  late RxString iDImage = ''.obs;
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
    nationalIdTextController.addListener(() {
      final nationalId = nationalIdTextController.text;
      if (nationalId.isNumericOnly && nationalId.length == 14) {
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
    }
  }

  Future<void> captureProfilePic() async {
    RegularBottomSheet.hideBottomSheet();
    final addedImage = await picker.pickImage(source: ImageSource.camera);
    if (addedImage != null) {
      isProfileImageAdded.value = true;
      profileImage.value = addedImage;
    }
  }

  Future<void> captureIDPic() async {
    RegularBottomSheet.hideBottomSheet();
    final imagesPath = await CunningDocumentScanner.getPictures();
    if (imagesPath!.isNotEmpty) {
      isNationalIDImageAdded.value = true;
      iDImage.value = imagesPath[0];
    }
  }

  Future<void> savePersonalInformation() async {
    showLoadingScreen();

    final name = nameTextController.text;
    final email = emailTextController.text;
    final nationalId = nationalIdTextController.text;

    highlightName.value = name.isEmpty ? true : false;
    highlightEmail.value = email.isEmail ? false : true;

    if (nationalId.isNumericOnly && nationalId.length == 14) {
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
      Get.offAll(() => const MedicalHistoryInsertPage(),
          transition: AppInit.getPageTransition());
    } else {
      showSimpleSnackBar(title: 'error'.tr, body: 'requiredFields'.tr);
    }
    hideLoadingScreen();
  }
}
