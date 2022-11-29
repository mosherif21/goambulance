import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_text_button.dart';
import 'package:goambulance/src/common_widgets/text_form_field_with_suffix_icon_button.dart';

import '../../../common_widgets/regular_bottom_sheet.dart';
import '../../../common_widgets/text_form_field.dart';
import '../../../constants/styles.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.height,
  }) : super(key: key);

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
              prefixIconData: Icons.person_outline_outlined,
            ),
            const SizedBox(height: 10),
            TextFormFieldRegularSuffixIcon(
              labelText: 'passwordLabel'.tr,
              hintText: 'passwordLabel'.tr,
              prefixIconData: Icons.password_outlined,
              suffixIconData: Icons.remove_red_eye_sharp,
              suffixIconButtonOnPressed: () {},
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: RegularTextButton(
                buttonText: 'forgotPassword'.tr,
                onPressed: () => RegularBottomSheet(
                  context: context,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [],
                    ),
                  ),
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
                child: Text('loginTextTitle'.tr,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
