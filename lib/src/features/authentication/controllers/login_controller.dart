import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../general/common_functions.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  Future<void> loginUser(String email, String password) async {
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
    hideLoadingScreen();
    if (returnMessage.compareTo('success') != 0) {
      showSimpleSnackBar(
        title: 'error'.tr,
        body: returnMessage,
      );
    }
  }
}
