import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/single_entry_screen.dart';
import '../../../../constants/app_init_constants.dart';
import '../../../../constants/assets_strings.dart';
import 'otp_verification.dart';

void getToPhoneVerificationScreen() => Get.to(
      () => SingleEntryScreen(
        title: 'phoneVerification'.tr,
        prefixIconData: Icons.email_outlined,
        lottieAssetAnim: kPhoneVerificationAnim,
        textFormTitle: 'phoneLabel'.tr,
        textFormHint: 'phoneFieldLabel'.tr,
        buttonTitle: 'continue'.tr,
        onPressed: (text) => Get.to(
            () => OTPVerificationScreen(
                  verificationType: 'phoneLabel'.tr,
                  lottieAssetAnim: kPhoneOTPAnim,
                  enteredString: '+2$text',
                ),
            transition: AppInit.getPageTransition()),
        inputType: InputType.phone,
      ),
      transition: AppInit.getPageTransition(),
    );
