import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_elevated_button.dart';

import '../../../../common_widgets/text_form_field.dart';
import '../../../../common_widgets/text_form_field_passwords.dart';

RxBool passwordHide = true.obs;
RxBool confirmPasswordHide = true.obs;

class EmailRegisterForm extends StatelessWidget {
  const EmailRegisterForm({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';
    String confirmPassword = '';
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
            const SizedBox(height: 10),
            TextFormFieldPassword(
              labelText: 'confirmPassword'.tr,
              onTextChanged: (text) => confirmPassword = text,
            ),
            const SizedBox(height: 6),
            RegularElevatedButton(
                buttonText: 'signupTextTitle'.tr, height: height),
          ],
        ),
      ),
    );
  }
}
