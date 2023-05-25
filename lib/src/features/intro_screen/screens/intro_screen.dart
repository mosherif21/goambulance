import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/features/authentication/screens/auth_screen.dart';
import 'package:goambulance/src/features/first_aid/screens/emergency_numbers_screen.dart';
import 'package:goambulance/src/features/first_aid/screens/first_aid_screen.dart';
import 'package:goambulance/src/general/common_widgets/or_divider.dart';
import 'package:line_icons/line_icon.dart';

import '../../../connectivity/connectivity.dart';
import '../../../constants/assets_strings.dart';
import '../../../constants/sizes.dart';
import '../../../general/app_init.dart';
import '../../../general/common_widgets/circle_button_text_icon.dart';
import '../../../general/common_widgets/language_change_button.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import '../../../general/general_functions.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    ConnectivityChecker.checkConnection(displayAlert: false);
    return Scaffold(
      body: SafeArea(
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
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
                    child: Hero(
                      tag: 'loginLogo',
                      child: Image(
                        image: const AssetImage(kLogoImage),
                        height: AppInit.notWebMobile
                            ? screenHeight * 0.27
                            : screenHeight * 0.22,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  AutoSizeText(
                    'welcome'.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5.0),
                  AutoSizeText(
                    'welcomeTitle'.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  RegularElevatedButton(
                    enabled: true,
                    buttonText: 'continue'.tr,
                    onPressed: () => Get.to(
                      () => const AuthenticationScreen(),
                      transition: getPageTransition(),
                    ),
                    color: kDefaultColor,
                  ),
                  const OrDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        CircleButtonIconAndText(
                          splashColor: kDefaultColorLessShade,
                          onPressed: () => Get.to(
                            () => const FirstAidScreen(),
                            transition: getPageTransition(),
                          ),
                          buttonText: 'firstAid'.tr,
                          iconColor: kDefaultColor,
                          buttonColor: kDefaultColorLessShade,
                          icon: LineIcon.firstAid(
                            color: kDefaultColor,
                            size: 40,
                          ),
                        ),
                        const Spacer(),
                        CircleButtonIconAndText(
                          splashColor: kDefaultColorLessShade,
                          onPressed: () => Get.to(
                            () => const EmergencyNumbersScreen(),
                            transition: getPageTransition(),
                          ),
                          buttonText: 'emergencyNumbers'.tr,
                          iconColor: kDefaultColor,
                          buttonColor: kDefaultColorLessShade,
                          icon: LineIcon.phone(
                            color: kDefaultColor,
                            size: 38,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
