import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/authentication/controllers/reset_password_controller.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:goambulance/src/general/validation_functions.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../constants/enums.dart';
import '../../../../constants/sizes.dart';
import '../../../../general/app_init.dart';

class LoggedInResetPasswordPage extends StatelessWidget {
  const LoggedInResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final controller = Get.put(ResetPasswordController());

    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Form(
        key: controller.formKey,
        child: Scaffold(
          appBar: AppBar(
            leading: const RegularBackButton(padding: 0),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPaddingSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      kEmailVerificationAnim,
                      fit: BoxFit.contain,
                      height: screenHeight * 0.4,
                    ),
                    AutoSizeText(
                      'loggedInPasswordResetLink'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: AppInit.notWebMobile ? 25 : 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      minFontSize: 10,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormFieldRegular(
                      labelText: 'emailLabel'.tr,
                      hintText: 'emailHintLabel'.tr,
                      prefixIconData: Icons.email_outlined,
                      textController: controller.emailController,
                      inputType: InputType.email,
                      editable: false,
                      textInputAction: TextInputAction.done,
                      validationFunction: validateEmail,
                    ),
                    const SizedBox(height: 20.0),
                    RegularElevatedButton(
                      buttonText: 'send'.tr,
                      enabled: true,
                      onPressed: () => controller.resetPassword(),
                      color: Colors.black,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
