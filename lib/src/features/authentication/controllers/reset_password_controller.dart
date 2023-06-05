import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../constants/enums.dart';
import '../../../general/general_functions.dart';

class ResetController extends GetxController {
  static ResetController get instance => Get.find();
  final emailController = TextEditingController();
  @override
  void onReady() {
    final user = AuthenticationRepository.instance.fireUser.value;
    if (user != null) {
      if (user.email != null) {
        emailController.text = user.email!;
      }
    }
    super.onReady();
  }

  Future<void> resetPassword(String email) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    String returnMessage = email.isEmpty
        ? 'missingEmail'.tr
        : !email.isEmail
            ? 'invalidEmailEntered'.tr
            : await AuthenticationRepository.instance
                .resetPassword(email: email);

    if (returnMessage == 'emailSent') {
      Get.back();
      showSnackBar(
        text: 'emailResetSuccess'.tr,
        snackBarType: SnackBarType.success,
      );
    } else {
      showSnackBar(
        text: returnMessage,
        snackBarType: SnackBarType.error,
      );
    }
    hideLoadingScreen();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
