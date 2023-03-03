import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

import '../../../../general/common_functions.dart';
import '../../../../general/common_widgets/or_divider.dart';
import 'phone_verification_screen.dart';

class AlternateLoginButtons extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final bool showPhoneLogin;
  const AlternateLoginButtons(
      {Key? key,
      required this.screenHeight,
      required this.screenWidth,
      required this.showPhoneLogin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonsWidth = screenWidth * 0.85;
    double buttonSpacing = screenHeight * 0.01;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OrDivider(screenHeight: screenHeight),
        showPhoneLogin
            ? Column(
                children: [
                  SignInButton(
                    Buttons.Phone,
                    text: 'loginWithMobile'.tr,
                    onPressed: () => getToPhoneVerificationScreen(),
                    width: buttonsWidth,
                    height: 50.0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  SizedBox(height: buttonSpacing),
                ],
              )
            : const SizedBox(),
        AppInit.isIos
            ? const SizedBox()
            : SignInButton(
                padding: const EdgeInsets.only(left: 5.0),
                Buttons.GoogleDark,
                text: 'loginWithGoogle'.tr,
                onPressed: () async {
                  showLoadingScreen();
                  var returnMessage = await AuthenticationRepository.instance
                      .signInWithGoogle();
                  hideLoadingScreen();
                  if (returnMessage.compareTo('success') != 0) {
                    showAwesomeSnackbar(
                        title: 'error'.tr,
                        body: returnMessage,
                        contentType: ContentType.failure);
                  }
                },
                width: buttonsWidth,
                height: 50.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
        SizedBox(height: buttonSpacing),
        SignInButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          Buttons.Facebook,
          text: 'loginWithFacebook'.tr,
          onPressed: () async {
            showLoadingScreen();
            var returnMessage =
                await AuthenticationRepository.instance.signInWithFacebook();
            hideLoadingScreen();
            if (returnMessage.compareTo('success') != 0) {
              showAwesomeSnackbar(
                title: 'error'.tr,
                body: returnMessage,
                contentType: ContentType.failure,
              );
            }
          },
          width: buttonsWidth,
          height: 50.0,
        ),
      ],
    );
  }
}
