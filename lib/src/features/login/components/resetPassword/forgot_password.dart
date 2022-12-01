import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/framed_button.dart';
import '../../../../common_widgets/single_entry_screen.dart';
import '../../../../constants/app_init_constants.dart';
import '../../../../constants/assets_strings.dart';
import 'otp_verification.dart';

class ForgetPasswordLayout extends StatelessWidget {
  const ForgetPasswordLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? screenHeight = Get.context?.height;

    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'chooseForgetPasswordMethod'.tr,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: screenHeight! * 0.02),
          FramedIconButton(
            title: 'emailLabel'.tr,
            subTitle: 'emailReset'.tr,
            iconData: Icons.mail_outline_rounded,
            onPressed: () => Get.to(
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
                transition: AppInit.getPageTransition()),
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            title: 'phoneLabel'.tr,
            subTitle: 'numberReset'.tr,
            iconData: Icons.mobile_friendly_rounded,
            onPressed: () => Get.to(
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
            ),
          ),
        ],
      ),
    );
  }
}
