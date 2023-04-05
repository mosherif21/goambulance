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
    final controller = Get.put(EmailRegisterController());
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
            editable: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          TextFormFieldPassword(
            labelText: 'passwordLabel'.tr,
            textController: controller.passwordTextController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          TextFormFieldPassword(
            labelText: 'confirmPassword'.tr,
            textController: controller.passwordConfirmTextController,
            textInputAction: TextInputAction.done,
            onSubmitted: () async => await controller.registerNewUser(),
          ),
          const SizedBox(height: 12),
          RegularElevatedButton(
            buttonText: 'registerTextTitle'.tr,
            enabled: true,
            onPressed: () async => await controller.registerNewUser(),
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
