import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';

import '../../../../constants/app_init_constants.dart';
import '../../../../general/common_functions.dart';
import '../../../../general/common_widgets/single_entry_screen.dart';
import '../../controllers/reset_password_controller.dart';

void getToResetPasswordScreen() {
  final controller = Get.put(ResetController());
  Get.to(
    () => SingleEntryScreen(
      title: 'emailVerification'.tr,
      prefixIconData: Icons.email_outlined,
      lottieAssetAnim: kEmailVerificationAnim,
      textFormTitle: 'emailLabel'.tr,
      textFormHint: 'emailHintLabel'.tr,
      buttonTitle: 'confirm'.tr,
      textController: controller.emailController,
      inputType: InputType.email,
      onPressed: () async {
        String returnMessage = '';
        String email = controller.emailController.value.text.trim();

        returnMessage = await controller.resetPassword(email);
        if (returnMessage.compareTo('emailSent') == 0) {
          Get.back();
          showSimpleSnackBar(
              'success'.tr, 'emailResetSuccess'.tr, SnackPosition.BOTTOM);
        } else {
          showSimpleSnackBar('error'.tr, returnMessage, SnackPosition.BOTTOM);
        }
      },
    ),
    transition: AppInit.getPageTransition(),
  );
}
