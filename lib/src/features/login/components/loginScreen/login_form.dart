import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_text_button.dart';
import 'package:goambulance/src/common_widgets/text_form_field_passwords.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/common_functions.dart';

import '../../../../common_widgets/regular_bottom_sheet.dart';
import '../../../../common_widgets/regular_elevated_button.dart';
import '../../../../common_widgets/text_form_field.dart';
import '../resetPassword/forgot_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = getScreenHeight(context);
    String email = '';
    String password = '';
    return Form(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormFieldRegular(
              labelText: 'emailLabel'.tr,
              hintText: 'emailHintLabel'.tr,
              prefixIconData: Icons.email_outlined,
              color: const Color(0xFF28AADC),
              onTextChanged: (text) => email = text,
            ),
            const SizedBox(height: 10),
            TextFormFieldPassword(
              labelText: 'passwordLabel'.tr,
              onTextChanged: (text) => password = text,
            ),
            const SizedBox(height: 6),
            Align(
              alignment: AppInit.currentDeviceLanguage == Language.english
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: RegularTextButton(
                buttonText: 'forgotPassword'.tr,
                onPressed: () => const RegularBottomSheet(
                  child: ForgetPasswordLayout(),
                ).showRegularBottomSheet(),
              ),
            ),
            const SizedBox(height: 6),
            RegularElevatedButton(
              buttonText: 'loginTextTitle'.tr,
              height: height,
            ),
          ],
        ),
      ),
    );
  }
}
