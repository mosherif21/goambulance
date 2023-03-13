import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/authentication/controllers/login_controller.dart';

import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/common_widgets/regular_text_button.dart';
import '../../../../general/common_widgets/text_form_field.dart';
import '../../../../general/common_widgets/text_form_field_passwords.dart';
import '../resetPassword/forgot_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormFieldRegular(
            labelText: 'emailLabel'.tr,
            hintText: 'emailHintLabel'.tr,
            prefixIconData: Icons.email_outlined,
            textController: controller.emailTextController,
            inputType: InputType.email,
          ),
          const SizedBox(height: 10),
          TextFormFieldPassword(
            labelText: 'passwordLabel'.tr,
            textController: controller.passwordTextController,
          ),
          const SizedBox(height: 6),
          Align(
            alignment: AppInit.currentDeviceLanguage == Language.english
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: RegularTextButton(
              buttonText: 'forgotPassword'.tr,
              onPressed: () => RegularBottomSheet.showRegularBottomSheet(
                  const ForgetPasswordLayout()),
            ),
          ),
          const SizedBox(height: 6),
          RegularElevatedButton(
            enabled: true,
            buttonText: 'loginTextTitle'.tr,
            onPressed: () async => await controller.loginUser(),
          ),
        ],
      ),
    );
  }
}
