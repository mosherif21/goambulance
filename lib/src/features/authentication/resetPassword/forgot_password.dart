import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/authentication/resetPassword/email_verification.dart';
import 'package:goambulance/src/features/authentication/resetPassword/phone_verification.dart';

import '../../../common_widgets/framed_button.dart';

class ForgetPasswordLayout extends StatelessWidget {
  const ForgetPasswordLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'chooseForgetPasswordMethod'.tr,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: screenHeight * 0.02),
        FramedIconButton(
          title: 'emailLabel'.tr,
          subTitle: 'emailReset'.tr,
          iconData: Icons.mail_outline_rounded,
          onPressed: () => Get.to(
            () => const EmailVerificationScreen(),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        FramedIconButton(
          title: 'phoneLabel'.tr,
          subTitle: 'numberReset'.tr,
          iconData: Icons.mobile_friendly_rounded,
          onPressed: () => Get.to(
            () => const PhoneVerificationScreen(),
          ),
        ),
      ],
    );
  }
}
