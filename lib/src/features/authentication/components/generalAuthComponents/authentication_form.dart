import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/authentication/controllers/register_controller.dart';

import '../../../../common_widgets/or_divider.dart';
import '../../../../common_widgets/regular_text_button.dart';
import '../../controllers/login_controller.dart';
import '../emailRegistration/email_register_form.dart';
import '../loginScreen/login_form.dart';
import 'alternate_login_buttons.dart';

enum AuthType { login, register }

final currentAuth = AuthType.login.obs;

class AuthenticationForm extends StatelessWidget {
  const AuthenticationForm({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);
  final double screenHeight;
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => currentAuth.value == AuthType.login
              ? const LoginForm()
              : const EmailRegisterForm()),
          OrDivider(screenHeight: screenHeight),
          AlternateLoginButtons(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.01),
          Obx(
            () => RegularTextButton(
              buttonText: currentAuth.value == AuthType.login
                  ? 'noEmailAccount'.tr
                  : 'alreadyHaveAnAccount'.tr,
              onPressed: () => currentAuth.value == AuthType.login
                  ? Get.delete<LoginController>()
                      .whenComplete(() => currentAuth.value = AuthType.register)
                  : Get.delete<RegisterController>()
                      .whenComplete(() => currentAuth.value = AuthType.login),
            ),
          ),
        ],
      ),
    );
  }
}
