import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/authentication/controllers/register_controller.dart';

import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/common_widgets/text_form_field.dart';
import '../../../../general/common_widgets/text_form_field_passwords.dart';

class EmailRegisterForm extends StatelessWidget {
  const EmailRegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    //final formKey = GlobalKey<FormState>();
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
              textController: controller.email,
              inputType: InputType.email,
            ),
            const SizedBox(height: 10),
            TextFormFieldPassword(
              labelText: 'passwordLabel'.tr,
              textController: controller.password,
            ),
            const SizedBox(height: 10),
            TextFormFieldPassword(
              labelText: 'confirmPassword'.tr,
              textController: controller.passwordConfirm,
            ),
            const SizedBox(height: 6),
            Obx(
              () => controller.returnMessage.value.compareTo('success') != 0
                  ? Text(
                      controller.returnMessage.value,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 6),
            RegularElevatedButton(
              buttonText: 'registerTextTitle'.tr,
              enabled: true,
              onPressed: () async {
                await controller.registerNewUser(
                  controller.email.text,
                  controller.password.text,
                  controller.passwordConfirm.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
