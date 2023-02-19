import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/language_change_button.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/features/authentication/components/loginScreen/alternate_login_buttons.dart';
import 'package:goambulance/src/features/authentication/controllers/login_controller.dart';

import '../../../common_widgets/or_divider.dart';
import '../../../common_widgets/regular_text_button.dart';
import '../../../connectivity/connectivity.dart';
import '../../../constants/app_init_constants.dart';
import '../../../constants/assets_strings.dart';
import '../../../general/common_functions.dart';
import '../components/loginScreen/login_form.dart';
import 'email_register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
    ConnectivityChecker.checkConnection(displayAlert: true);
    Get.put(LoginController());
    Widget widget;
    switch (AppInit.getScreenSize(MediaQuery.of(context).size.width)) {
      case ScreenSize.small:
        widget = loginPageSmall(
            screenHeight: screenHeight, screenWidth: screenWidth);
        break;
      case ScreenSize.medium:
        widget = loginPageMedium(
            screenHeight: screenHeight, screenWidth: screenWidth);
        break;
      case ScreenSize.large:
        widget = loginPageLarge(
            screenHeight: screenHeight, screenWidth: screenWidth);
        break;
    }
    return SafeArea(child: widget);
  }
}

Widget loginPageSmall(
    {required double screenHeight, required double screenWidth}) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
            left: kDefaultPaddingSize,
            right: kDefaultPaddingSize,
            bottom: kDefaultPaddingSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ButtonLanguageSelect(),
            Image(
              image: const AssetImage(kLogoImageWithSlogan),
              height: screenHeight * 0.25,
            ),
            SizedBox(height: screenHeight * 0.02),
            const LoginForm(),
            OrDivider(screenHeight: screenHeight),
            AlternateLoginButtons(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
            SizedBox(height: screenHeight * 0.01),
            RegularTextButton(
              buttonText: 'noEmailAccount'.tr,
              onPressed: () => Get.to(
                () => const EmailRegisterScreen(),
                transition: AppInit.getPageTransition(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget loginPageMedium(
    {required double screenHeight, required double screenWidth}) {
  return const Scaffold();
}

Widget loginPageLarge(
    {required double screenHeight, required double screenWidth}) {
  return const Scaffold();
}
