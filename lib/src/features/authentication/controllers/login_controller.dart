import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../general/general_functions.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  Future<void> loginUser() async {
    final email = emailTextController.text;
    final password = passwordTextController.text;
    String returnMessage = '';
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    if (email.isEmail && password.length >= 8) {
      returnMessage = await AuthenticationRepository.instance
          .signInWithEmailAndPassword(email, password);
    } else if (email.isEmpty || password.isEmpty) {
      returnMessage = 'emptyFields'.tr;
    } else if (password.length < 8) {
      returnMessage = 'smallPass'.tr;
    } else {
      returnMessage = 'invalidEmailEntered'.tr;
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
    super.dispose();
  }
}
