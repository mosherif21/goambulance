import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_init_constants.dart';
import '../../../../constants/assets_strings.dart';
import '../../../../general/common_widgets/single_entry_screen.dart';
import '../../controllers/otp_verification_controller.dart';

void getToPhoneVerificationScreen() {
  final controller = Get.put(OtpVerificationController());
  Get.to(
    () => SingleEntryScreen(
      title: 'phoneVerification'.tr,
      prefixIconData: Icons.phone,
      lottieAssetAnim: kPhoneVerificationAnim,
      textFormTitle: 'phoneLabel'.tr,
      textFormHint: 'phoneFieldLabel'.tr,
      buttonTitle: 'continue'.tr,
      textController: controller.enteredData,
      inputType: InputType.phone,
      onPressed: () async => await controller.otpOnClick(),
    ),
    transition: AppInit.getPageTransition(),
  );
}
