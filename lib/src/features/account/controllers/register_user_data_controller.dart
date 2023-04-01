import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:eg_nid/eg_nid.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../authentication/authentication_repository.dart';
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
  Gender gender = Gender.male;
  RxBool nationalIdGenderSet = false.obs;

  //images
  final picker = ImagePicker();
  late Rx<XFile?> profileImage = XFile('').obs;
  late RxString iDImage = ''.obs;
  RxBool isProfileImageAdded = false.obs;
  RxBool isIDImageAdded = false.obs;

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
      if (nationalId.length == 14) {
        final nationalIdData = NIDInfo(nid: nationalId);
        final birthDate = nationalIdData.birthDay;
        birthDateController.displayDate = birthDate;
        birthDateController.selectedDate =
            DateTime(birthDate.year, birthDate.month, birthDate.day);
        gender = nationalIdData.sex.compareTo('Male') == 0
            ? Gender.male
            : Gender.female;
        nationalIdGenderSet.value = true;
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
      isIDImageAdded.value = true;
      iDImage.value = imagesPath[0];
    }
  }
}
