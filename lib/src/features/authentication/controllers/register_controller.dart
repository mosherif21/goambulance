import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../general/common_functions.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();

  Future<void> registerNewUser(
      String email, String password, String passwordConfirm) async {
    String returnMessage = '';
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    if (password.compareTo(passwordConfirm) == 0 && password.length >= 8) {
      returnMessage = await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);
    } else if (email.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      returnMessage = 'emptyFields'.tr;
    } else if (password.length < 8) {
      returnMessage = 'smallPass'.tr;
    } else {
      returnMessage = 'passwordNotMatch'.tr;
    }
    hideLoadingScreen();
    if (returnMessage.compareTo('success') != 0) {
      showSimpleSnackBar(
        title: 'error'.tr,
        body: returnMessage,
      );
    }
  }
}
