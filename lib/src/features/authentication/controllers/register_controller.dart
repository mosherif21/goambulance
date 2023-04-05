import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../general/common_functions.dart';

class EmailRegisterController extends GetxController {
  static EmailRegisterController get instance => Get.find();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final passwordConfirmTextController = TextEditingController();

  Future<void> registerNewUser() async {
    final email = emailTextController.text;
    final password = passwordTextController.text;
    final passwordConfirm = passwordConfirmTextController.text;
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
    if (returnMessage.compareTo('success') != 0) {
      hideLoadingScreen();
      showSimpleSnackBar(
        text: returnMessage,
      );
    }
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    passwordConfirmTextController.dispose();
    super.dispose();
  }
}
