import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../authentication/authentication_repository.dart';

enum Gender {
  male,
  female,
}

class RegisterUserDataController extends GetxController {
  static RegisterUserDataController get instance => Get.find();
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final nationalIdTextController = TextEditingController();
  final birthDateController = DateRangePickerController();
  final picker = ImagePicker();
  String gender = '';
  late Rx<XFile?> image = XFile('').obs;
  RxBool isProfileImageAdded = false.obs;

  @override
  void onInit() async {
    super.onInit();
    final user = AuthenticationRepository.instance.fireUser.value;
    final userEmail = user?.email ?? '';
    final userName = user?.displayName ?? '';
    nameTextController.text = userName;
    emailTextController.text = userEmail;
  }

  Future<void> pickProfilePic() async {
    Get.back();
    final addedImage = await picker.pickImage(source: ImageSource.gallery);
    if (addedImage != null) {
      isProfileImageAdded.value = true;
      image.value = addedImage;
    }
  }

  Future<void> captureProfilePic() async {
    Get.back();
    final addedImage = await picker.pickImage(source: ImageSource.camera);
    if (addedImage != null) {
      isProfileImageAdded.value = true;
      image.value = addedImage;
    }
  }
}
