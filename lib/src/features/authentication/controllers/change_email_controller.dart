import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../constants/enums.dart';
import '../../../general/general_functions.dart';

class ChangeEmailController extends GetxController {
  static ChangeEmailController get instance => Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> changeEmail() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final email = emailController.text.trim();
    showLoadingScreen();
    String returnMessage = email.isEmpty
        ? 'missingEmail'.tr
        : !email.isEmail
            ? 'invalidEmailEntered'.tr
            : await AuthenticationRepository.instance.changeEmail(email, '');

    if (returnMessage == 'emailSent') {
      Get.back();
      showSnackBar(
        text: 'emailChangedSuccess'.tr,
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
    passwordController.dispose();
    super.onClose();
  }
}
