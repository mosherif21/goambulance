import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_text_button.dart';
import 'package:goambulance/src/common_widgets/text_form_field_passwords.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

import '../../../../common_widgets/regular_bottom_sheet.dart';
import '../../../../common_widgets/text_form_field.dart';
import '../../../../constants/styles.dart';
import '../../../authentication/resetPassword/forgot_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              width: double.infinity,
              height: height * 0.05,
              child: ElevatedButton(
                style: kElevatedButtonRegularStyle,
                onPressed: () {},
                child: Text(
                  'loginTextTitle'.tr,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
