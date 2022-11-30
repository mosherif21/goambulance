import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/login/screens/login_screen.dart';

import '../../../common_widgets/regular_text_button.dart';
import '../../../connectivity/connectivity.dart';
import '../../../constants/assets_strings.dart';
import '../../../constants/sizes.dart';
import '../../login/components/loginScreen/alternate_login_buttons.dart';
import 'email_register_form.dart';

class EmailRegisterScreen extends StatelessWidget {
  const EmailRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    // ConnectivityController connectivityController =
    ConnectivityChecker.checkConnection(context, screenHeight, true);
    // final String email;
    // final String password;
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
                EmailRegisterForm(height: screenHeight),
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
                  screenWidth: screenWidth,
                ),
                const SizedBox(height: 6),
                RegularTextButton(
                  buttonText: 'alreadyHaveAnAccount'.tr,
                  onPressed: () => Get.offAll(
                    () => const LoginScreen(),
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
