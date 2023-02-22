import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

import '../../../../general/common_functions.dart';
import '../../../../general/common_widgets/or_divider.dart';

class AlternateLoginButtonsPhone extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const AlternateLoginButtonsPhone(
      {Key? key, required this.screenHeight, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonsWidth = screenWidth * 0.85;
    double buttonSpacing = screenHeight * 0.01;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OrDivider(screenHeight: screenHeight),
          const SizedBox(height: 10.0),
          AppInit.isIos
              ? const SizedBox()
              : SignInButton(
                  Buttons.GoogleDark,
                  text: 'loginWithGoogle'.tr,
                  onPressed: () async {
                    showLoadingScreen();
                    var returnMessage = await AuthenticationRepository.instance
                        .signInWithGoogle();
                    hideLoadingScreen();
                    if (returnMessage.compareTo('success') != 0) {
                      showSimpleSnackBar(
                        'error'.tr,
                        returnMessage,
                      );
                    }
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
                  'error'.tr,
                  returnMessage,
                );
              }
            },
            width: buttonsWidth,
            height: 50.0,
          ),
        ],
      ),
    );
  }
}
