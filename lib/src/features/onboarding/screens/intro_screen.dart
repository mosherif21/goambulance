import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/features/authentication/screens/auth_screen.dart';
import 'package:goambulance/src/general/common_widgets/or_divider.dart';

import '../../../connectivity/connectivity.dart';
import '../../../constants/app_init_constants.dart';
import '../../../constants/assets_strings.dart';
import '../../../constants/sizes.dart';
import '../../../general/common_functions.dart';
import '../../../general/common_widgets/language_change_button.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    ConnectivityChecker.checkConnection(displayAlert: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
                top: 15.0,
                left: kDefaultPaddingSize,
                right: kDefaultPaddingSize,
                bottom: kDefaultPaddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ButtonLanguageSelect(color: Colors.black54),
                Center(
                  child: Image(
                    image: const AssetImage(kLogoImage),
                    height: AppInit.notWebMobile
                        ? screenHeight * 0.27
                        : screenHeight * 0.22,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'welcome'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'welcomeTitle'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                RegularElevatedButton(
                  enabled: true,
                  buttonText: 'continue'.tr,
                  onPressed: () async => await Get.to(
                    () => const AuthenticationScreen(),
                    transition: AppInit.getPageTransition(),
                  ),
                  color: kDefaultColor,
                ),
                const OrDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
