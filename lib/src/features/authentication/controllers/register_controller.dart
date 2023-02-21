import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../general/common_functions.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();
  RxString returnMessage = ''.obs;

  Future<void> registerNewUser(
      String email, String password, String passwordConfirm) async {
    if (kDebugMode) {
      print('email register data is: email: $email and password: $password');
    }
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    if (password.compareTo(passwordConfirm) == 0 && password.length >= 8) {
      returnMessage.value = await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);
    } else if (email.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      returnMessage.value = 'emptyFields'.tr;
    } else if (password.length < 8) {
      returnMessage.value = 'smallPass'.tr;
    } else {
      returnMessage.value = 'passwordNotMatch'.tr;
    }
    hideLoadingScreen();
  }
}
