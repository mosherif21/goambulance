import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_text_button.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

class AlternateLoginButtons extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const AlternateLoginButtons(
      {Key? key, required this.screenHeight, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonsHeight =
        AppInit.notWebMobile ? screenHeight * 0.06 : screenHeight * 0.05;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Divider(
                  color: Colors.black54,
                  height: 8.0,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                'alternateLoginLabel'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenHeight * 0.02,
                    color: Colors.black54),
              ),
              const SizedBox(
                width: 8.0,
              ),
              const Expanded(
                child: Divider(
                  color: Colors.black54,
                  height: 8.0,
                ),
              )
            ],
          ),
        ),
        SignInButton(
          Buttons.Phone,
          text: 'loginWithMobile'.tr,
          onPressed: () {},
          height: buttonsHeight,
          width: screenWidth,
        ),
        const SizedBox(height: 6),
        SignInButton(
          Buttons.GoogleDark,
          text: 'loginWithGoogle'.tr,
          onPressed: () {},
          height: buttonsHeight,
          width: screenWidth,
        ),
        const SizedBox(height: 6),
        SignInButton(
          Buttons.Facebook,
          text: 'loginWithFacebook'.tr,
          onPressed: () {},
          height: buttonsHeight,
          width: screenWidth,
        ),
        const SizedBox(height: 6),
        RegularTextButton(
          buttonText: 'noEmailAccount'.tr,
          onPressed: () {},
        )
      ],
    );
  }
}
