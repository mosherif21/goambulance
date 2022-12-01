import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/features/login/components/loginScreen/alternate_login_buttons.dart';

import '../../../common_widgets/or_divider.dart';
import '../../../common_widgets/regular_text_button.dart';
import '../../../connectivity/connectivity.dart';
import '../../../constants/app_init_constants.dart';
import '../../../constants/assets_strings.dart';
import '../../../constants/common_functions.dart';
import '../components/emailRegistration/email_register_screen.dart';
import '../components/loginScreen/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
    // ConnectivityController connectivityController =
    ConnectivityChecker.checkConnection(true);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPaddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage(kLogoImageWithSlogan),
                  height: screenHeight * 0.25,
                ),
                const SizedBox(height: 10),
                const LoginForm(),
                OrDivider(screenHeight: screenHeight),
                AlternateLoginButtons(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
                const SizedBox(height: 6),
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
      ),
    );
  }
}
