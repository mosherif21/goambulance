import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/features/authentication/controllers/register_controller.dart';

import '../../../connectivity/connectivity.dart';
import '../../../constants/app_init_constants.dart';
import '../../../constants/assets_strings.dart';
import '../../../general/common_functions.dart';
import '../../../general/common_widgets/language_change_button.dart';
import '../components/generalAuthComponents/authentication_form.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
    ConnectivityChecker.checkConnection(displayAlert: true);
    Widget authWidget;
    switch (AppInit.getScreenSize(screenWidth)) {
      case ScreenSize.small:
        authWidget = authScreenSmall(
            screenHeight: screenHeight, screenWidth: screenWidth);
        break;
      case ScreenSize.medium:
        authWidget = authScreenMedium(
            screenHeight: screenHeight, screenWidth: screenWidth);
        break;
      case ScreenSize.large:
        authWidget = authScreenLarge(
            screenHeight: screenHeight, screenWidth: screenWidth);
        break;
    }
    return WillPopScope(
        onWillPop: () async {
          if (AppInit.currentAuthType.value == AuthType.emailRegister) {
            AppInit.currentAuthType.value = AuthType.emailLogin;
            Get.delete<RegisterController>();
            return false;
          } else {
            return true;
          }
        },
        child: authWidget);
  }

  Widget authScreenSmall(
      {required double screenHeight, required double screenWidth}) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
                left: kDefaultPaddingSize,
                right: kDefaultPaddingSize,
                bottom: kDefaultPaddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.01),
                const ButtonLanguageSelect(
                  color: Colors.black54,
                ),
                Image(
                  image: const AssetImage(kLogoImageWithSlogan),
                  height: screenHeight * 0.2,
                ),
                SizedBox(height: screenHeight * 0.02),
                AuthenticationForm(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget authScreenMedium(
      {required double screenHeight, required double screenWidth}) {
    return const Scaffold();
  }

  Widget authScreenLarge(
      {required double screenHeight, required double screenWidth}) {
    return const Scaffold();
  }
}
