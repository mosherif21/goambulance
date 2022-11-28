import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_text_button.dart';

class AlternateLoginButtons extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const AlternateLoginButtons(
      {Key? key, required this.screenHeight, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Text(
            'alternateLoginLabel'.tr,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: screenHeight * 0.02,
                color: Colors.black54),
          ),
        ),
        SignInButton(
          Buttons.Phone,
          text: 'loginWithMobile'.tr,
          onPressed: () {},
          height: screenHeight,
          width: screenWidth,
        ),
        SizedBox(height: screenHeight * 0.01),
        SignInButton(
          Buttons.GoogleDark,
          text: 'loginWithGoogle'.tr,
          onPressed: () {},
          height: screenHeight,
          width: screenWidth,
        ),
        SizedBox(height: screenHeight * 0.01),
        SignInButton(
          Buttons.Facebook,
          text: 'loginWithFacebook'.tr,
          onPressed: () {},
          height: screenHeight,
          width: screenWidth,
        ),
        SizedBox(height: screenHeight * 0.02),
        RegularTextButton(
          buttonText: 'noEmailAccount'.tr,
          onPressed: () {},
        )
      ],
    );
  }
}
