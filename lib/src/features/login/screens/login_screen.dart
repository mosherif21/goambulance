import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/features/login/components/loginScreen/alternate_login_buttons.dart';

import '../../../common_widgets/regular_text_button.dart';
import '../../../connectivity/connectivity.dart';
import '../../../constants/app_init_constants.dart';
import '../../../constants/assets_strings.dart';
import '../components/emailRegistration/email_register_screen.dart';
import '../components/loginScreen/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.context?.height;
    final screenWidth = Get.context?.width;
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
                  height: screenHeight! * 0.25,
                ),
                const SizedBox(height: 10),
                LoginForm(height: screenHeight),
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
                AlternateLoginButtons(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth!,
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
