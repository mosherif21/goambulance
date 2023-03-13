import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_init_constants.dart';
import '../../../../constants/assets_strings.dart';
import '../../../../general/common_functions.dart';
import '../../../../general/common_widgets/single_entry_screen.dart';
import '../../controllers/otp_verification_controller.dart';
import '../otpVerification/otp_verification.dart';

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
      onPressed: () async {
        var phoneNumber = controller.enteredData.value.text;
        var returnMessage = '';
        returnMessage = await controller.signInWithOTPPhone(phoneNumber);
        if (returnMessage.compareTo('codeSent') == 0) {
          await Get.to(
              () => OTPVerificationScreen(
                    inputType: InputType.phone,
                    verificationType: 'phoneLabel'.tr,
                    lottieAssetAnim: kPhoneOTPAnim,
                    enteredString: phoneNumber,
                  ),
              transition: AppInit.getPageTransition());
        } else {
          showSimpleSnackBar(
            title: 'error'.tr,
            body: returnMessage,
          );
        }
      },
    ),
    transition: AppInit.getPageTransition(),
  );
}
