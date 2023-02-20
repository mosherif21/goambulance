import 'package:flutter/material.dart';
import 'package:goambulance/src/common_widgets/language_change_button.dart';
import 'package:goambulance/src/constants/sizes.dart';

import '../../../connectivity/connectivity.dart';
import '../../../constants/app_init_constants.dart';
import '../../../constants/assets_strings.dart';
import '../../../general/common_functions.dart';
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
    return SafeArea(
      child: Scaffold(body: authWidget),
    );
  }
}

Widget authScreenSmall(
    {required double screenHeight, required double screenWidth}) {
  return SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.only(
          left: kDefaultPaddingSize,
          right: kDefaultPaddingSize,
          bottom: kDefaultPaddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.01),
          const ButtonLanguageSelect(),
          Image(
            image: const AssetImage(kLogoImageWithSlogan),
            height: screenHeight * 0.25,
          ),
          SizedBox(height: screenHeight * 0.02),
          AuthenticationForm(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
        ],
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
