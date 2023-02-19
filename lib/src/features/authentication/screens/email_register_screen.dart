import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/or_divider.dart';
import 'package:goambulance/src/general/common_functions.dart';

import '../../../common_widgets/language_change_button.dart';
import '../../../common_widgets/regular_text_button.dart';
import '../../../constants/assets_strings.dart';
import '../../../constants/sizes.dart';
import '../components/emailRegistration/email_register_form.dart';
import '../components/loginScreen/alternate_login_buttons.dart';

class EmailRegisterScreen extends StatelessWidget {
  const EmailRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
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
                const ButtonLanguageSelect(),
                Image(
                  image: const AssetImage(kLogoImageWithSlogan),
                  height: screenHeight * 0.25,
                ),
                SizedBox(height: screenHeight * 0.02),
                EmailRegisterForm(height: screenHeight),
                OrDivider(screenHeight: screenHeight),
                AlternateLoginButtons(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.01),
                RegularTextButton(
                  buttonText: 'alreadyHaveAnAccount'.tr,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
