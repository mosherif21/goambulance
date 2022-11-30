import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/text_form_field.dart';
import '../../../common_widgets/text_form_field_with_suffix_icon_button.dart';
import '../../../constants/styles.dart';

class EmailRegisterForm extends StatelessWidget {
  const EmailRegisterForm({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
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
            ),
            const SizedBox(height: 10),
            TextFormFieldRegularSuffixIcon(
              labelText: 'passwordLabel'.tr,
              hintText: 'passwordHintLabel'.tr,
              prefixIconData: Icons.lock_outlined,
              suffixIconData: Icons.remove_red_eye_sharp,
              suffixIconButtonOnPressed: () {},
            ),
            const SizedBox(height: 10),
            TextFormFieldRegularSuffixIcon(
              labelText: 'confirmPassword'.tr,
              hintText: 'passwordHintLabel'.tr,
              prefixIconData: Icons.lock_outlined,
              suffixIconData: Icons.remove_red_eye_sharp,
              suffixIconButtonOnPressed: () {},
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: height * 0.05,
              child: ElevatedButton(
                style: kElevatedButtonRegularStyle,
                onPressed: () {},
                child: Text(
                  'signupTextTitle'.tr,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
