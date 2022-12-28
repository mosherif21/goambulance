import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../routing/loading_screen.dart';

class ResetController extends GetxController {
  static ResetController get instance => Get.find();
  final emailController = TextEditingController();

  Future<String> resetPassword(String email) async {
    if (kDebugMode) {
      print('email reset data is: $email');
    }
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    var returnMessage =
        await AuthenticationRepository.instance.resetPassword(email: email);
    hideLoadingScreen();
    return returnMessage;
  }
}
