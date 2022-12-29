import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // ConnectivityController connectivityController =
    ConnectivityChecker.checkConnection(true);
    Get.put(LoginController());
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
      ),
    );
  }
}
