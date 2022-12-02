import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/single_entry_screen.dart';
import '../../../../constants/app_init_constants.dart';
import '../../../../constants/assets_strings.dart';
import 'otp_verification.dart';

void getToEmailVerificationScreen() => Get.to(
    () => SingleEntryScreen(
          title: 'emailVerification'.tr,
          prefixIconData: Icons.email_outlined,
          lottieAssetAnim: kEmailVerificationAnim,
          textFormTitle: 'emailLabel'.tr,
          textFormHint: 'emailHintLabel'.tr,
          buttonTitle: 'continue'.tr,
          onPressed: (text) => Get.to(
              () => OTPVerificationScreen(
                    verificationType: 'emailLabel'.tr,
                    lottieAssetAnim: kEmailOTPAnim,
                    enteredString: text,
                  ),
              transition: AppInit.getPageTransition()),
          inputType: InputType.email,
        ),
    transition: AppInit.getPageTransition());
