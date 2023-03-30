import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/authentication/controllers/register_controller.dart';

import '../../../../general/common_widgets/regular_text_button.dart';
import '../../controllers/login_controller.dart';
import '../emailRegistration/email_register_form.dart';
import '../loginScreen/login_form.dart';
import 'alternate_login_buttons.dart';

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
          Obx(() => AppInit.currentAuthType.value == AuthType.emailLogin
              ? const LoginForm()
              : const EmailRegisterForm()),
          AlternateLoginButtons(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            showPhoneLogin: true,
          ),
          SizedBox(height: screenHeight * 0.002),
          Obx(
            () => RegularTextButton(
              buttonText: AppInit.currentAuthType.value == AuthType.emailLogin
                  ? 'noEmailAccount'.tr
                  : 'alreadyHaveAnAccount'.tr,
              onPressed: () async => AppInit.currentAuthType.value ==
                      AuthType.emailLogin
                  ? await Get.delete<LoginController>().whenComplete(() =>
                      AppInit.currentAuthType.value = AuthType.emailRegister)
                  : await Get.delete<EmailRegisterController>().whenComplete(
                      () =>
                          AppInit.currentAuthType.value = AuthType.emailLogin),
            ),
          ),
        ],
      ),
    );
  }
}
