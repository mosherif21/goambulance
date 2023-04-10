import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';

import '../../../../constants/app_init_constants.dart';
import '../../../../general/common_widgets/single_entry_screen.dart';

void getToResetPasswordScreen() {
  Get.to(
    () => SingleEntryScreen(
      title: 'passwordResetLink'.tr,
      prefixIconData: Icons.email_outlined,
      lottieAssetAnim: kEmailVerificationAnim,
      textFormTitle: 'emailLabel'.tr,
      textFormHint: 'emailHintLabel'.tr,
      buttonTitle: 'confirm'.tr,
      inputType: InputType.email,
      linkWithPhone: false,
    ),
    transition: AppInit.getPageTransition(),
  );
}
