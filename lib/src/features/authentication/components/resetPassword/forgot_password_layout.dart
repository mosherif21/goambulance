import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/general_functions.dart';

import '../../../../general/common_widgets/framed_button.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';

class ForgetPasswordLayout extends StatelessWidget {
  const ForgetPasswordLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'chooseForgetPasswordMethod'.tr,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black87),
            maxLines: 2,
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'emailLabel'.tr,
            subTitle: 'emailReset'.tr,
            iconData: Icons.mail_outline_rounded,
            onPressed: () {
              RegularBottomSheet.hideBottomSheet();
              getToResetPasswordScreen();
            },
          ),
        ],
      ),
    );
  }
}
