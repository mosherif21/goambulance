import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_bottom_sheet.dart';
import 'package:goambulance/src/constants/common_functions.dart';

import '../../../../common_widgets/framed_button.dart';
import '../otpVerification/email_verification_screen.dart';
import '../otpVerification/phone_verification_screen.dart';

class ForgetPasswordLayout extends StatelessWidget {
  const ForgetPasswordLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = getScreenHeight(context);

    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'chooseForgetPasswordMethod'.tr,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'emailLabel'.tr,
            subTitle: 'emailReset'.tr,
            iconData: Icons.mail_outline_rounded,
            onPressed: () {
              RegularBottomSheet.hideBottomSheet();
              getToEmailVerificationScreen();
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'phoneLabel'.tr,
            subTitle: 'numberReset'.tr,
            iconData: Icons.mobile_friendly_rounded,
            onPressed: () {
              RegularBottomSheet.hideBottomSheet();
              getToPhoneVerificationScreen();
            },
          ),
        ],
      ),
    );
  }
}
