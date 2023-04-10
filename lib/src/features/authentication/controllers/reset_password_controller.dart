import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../general/general_functions.dart';

class ResetController extends GetxController {
  static ResetController get instance => Get.find();
  final emailController = TextEditingController();

  Future<void> resetPassword(String email) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    String returnMessage = email.isEmpty
        ? 'missingEmail'.tr
        : !email.isEmail
            ? 'invalidEmailEntered'.tr
            : await AuthenticationRepository.instance
                .resetPassword(email: email);

    if (returnMessage.compareTo('emailSent') == 0) {
      Get.back();
      showSimpleSnackBar(
        text: 'emailResetSuccess'.tr,
      );
    } else {
      showSimpleSnackBar(
        text: returnMessage,
      );
    }
    hideLoadingScreen();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
