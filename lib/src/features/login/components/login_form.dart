import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_text_button.dart';

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
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.person_outline_outlined,
                ),
                labelText: 'emailLabel'.tr,
                hintText: 'emailHintLabel'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: height * 0.02),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.fingerprint,
                ),
                labelText: 'passwordLabel'.tr,
                hintText: 'passwordLabel'.tr,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.remove_red_eye_sharp,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Align(
              alignment: Alignment.centerRight,
              child: RegularTextButton(
                buttonText: 'forgotPassword'.tr,
                onPressed: () {},
              ),
            ),
            SizedBox(height: height * 0.01),
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
