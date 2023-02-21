import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

import '../../../../general/common_functions.dart';
import '../otpVerification/phone_verification_screen.dart';

class AlternateLoginButtons extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const AlternateLoginButtons(
      {Key? key, required this.screenHeight, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonsWidth = screenWidth * 0.85;
    double buttonSpacing = screenHeight * 0.01;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SignInButton(
          Buttons.Phone,
          text: 'loginWithMobile'.tr,
          onPressed: () => getToPhoneVerificationScreen(),
          width: buttonsWidth,
          height: 50.0,
        ),
        SizedBox(height: buttonSpacing),
        AppInit.isIos
            ? const SizedBox()
            : SignInButton(
                Buttons.GoogleDark,
                text: 'loginWithGoogle'.tr,
                onPressed: () async {
                  // showLoadingScreen();
                  // var returnMessage = await AuthenticationRepository.instance
                  //     .signInWithGoogle();
                  // hideLoadingScreen();
                  // if (returnMessage.compareTo('success') != 0) {
                  //   showSimpleSnackBar(
                  //       'error'.tr, returnMessage, SnackPosition.BOTTOM);
                  // }

                  showLoadingScreen();
                  hideLoadingScreen();
                  showSimpleSnackBar("ay7aga", "ay7aga", SnackPosition.BOTTOM);
                },
                width: buttonsWidth,
                height: 50.0,
              ),
        SizedBox(height: buttonSpacing),
        SignInButton(
          Buttons.Facebook,
          text: 'loginWithFacebook'.tr,
          onPressed: () async {
            showLoadingScreen();
            var returnMessage =
                await AuthenticationRepository.instance.signInWithFacebook();
            hideLoadingScreen();
            if (returnMessage.compareTo('success') != 0) {
              showSimpleSnackBar(
                  'error'.tr, returnMessage, SnackPosition.BOTTOM);
            }
          },
          width: buttonsWidth,
          height: 50.0,
        ),
      ],
    );
  }
}
