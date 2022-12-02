import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/authentication/controllers/otp_verification_controller.dart';

import '../../../../common_widgets/single_entry_screen.dart';
import '../../../../constants/app_init_constants.dart';
import '../../../../constants/assets_strings.dart';
import 'otp_verification.dart';

void getToEmailVerificationScreen() {
  final controller = Get.put(OtpVerificationController());
  Get.to(
    () => SingleEntryScreen(
      title: 'emailVerification'.tr,
      prefixIconData: Icons.email_outlined,
      lottieAssetAnim: kEmailVerificationAnim,
      textFormTitle: 'emailLabel'.tr,
      textFormHint: 'emailHintLabel'.tr,
      buttonTitle: 'continue'.tr,
      onPressed: () => Get.to(
          () => OTPVerificationScreen(
                verificationType: 'emailLabel'.tr,
                lottieAssetAnim: kEmailOTPAnim,
                enteredString: 'text',
              ),
          transition: AppInit.getPageTransition()),
      inputType: InputType.email,
      textController: controller.enteredData,
    ),
    transition: AppInit.getPageTransition(),
  );
}
