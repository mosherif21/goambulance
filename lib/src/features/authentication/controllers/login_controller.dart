import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../routing/loading_screen.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  RxString returnMessage = ''.obs;
  Future<void> loginUser(String email, String password) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    if (email.isEmail && password.length >= 8) {
      returnMessage.value = await AuthenticationRepository.instance
          .signInWithEmailAndPassword(email, password);
    } else if (email.isEmpty || password.isEmpty) {
      returnMessage.value = 'emptyFields'.tr;
    } else if (password.length < 8) {
      returnMessage.value = 'smallPass'.tr;
    } else {
      returnMessage.value = 'invalidEmailEntered'.tr;
    }
    hideLoadingScreen();
    if (kDebugMode) {
      print('login data is: email: $email and password: $password');
      print(returnMessage.value);
    }
  }
}
