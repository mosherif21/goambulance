import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/single_entry_screen.dart';
import '../../../../constants/app_init_constants.dart';
import '../../../../constants/assets_strings.dart';
import '../../controllers/otp_verification_controller.dart';
import 'otp_verification.dart';

void getToPhoneVerificationScreen() {
  final controller = Get.put(OtpVerificationController());
  Get.to(
    () => SingleEntryScreen(
      title: 'phoneVerification'.tr,
      prefixIconData: Icons.email_outlined,
      lottieAssetAnim: kPhoneVerificationAnim,
      textFormTitle: 'phoneLabel'.tr,
      textFormHint: 'phoneFieldLabel'.tr,
      buttonTitle: 'continue'.tr,
      onPressed: () => Get.to(
          () => OTPVerificationScreen(
                verificationType: 'phoneLabel'.tr,
                lottieAssetAnim: kPhoneOTPAnim,
                enteredString: '+2text',
              ),
          transition: AppInit.getPageTransition()),
      inputType: InputType.phone,
      textController: controller.enteredData,
    ),
    transition: AppInit.getPageTransition(),
  );
}
