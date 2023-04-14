import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/authentication/controllers/otp_verification_controller.dart';
import 'package:goambulance/src/features/authentication/controllers/reset_password_controller.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';

import '../../constants/app_init_constants.dart';
import '../../constants/sizes.dart';
import '../../features/authentication/components/generalAuthComponents/alternate_login_buttons.dart';

class SingleEntryScreen extends StatelessWidget {
  const SingleEntryScreen({
    Key? key,
    required this.title,
    required this.lottieAssetAnim,
    required this.textFormTitle,
    required this.textFormHint,
    required this.buttonTitle,
    required this.prefixIconData,
    required this.inputType,
    required this.linkWithPhone,
  }) : super(key: key);
  final String title;
  final String lottieAssetAnim;
  final String textFormTitle;
  final String textFormHint;
  final String buttonTitle;
  final IconData prefixIconData;
  final InputType inputType;
  final bool linkWithPhone;

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
    if (inputType == InputType.phone) {
      Get.put(OtpVerificationController());
    } else if (inputType == InputType.email) {
      Get.put(ResetController());
    }
    return WillPopScope(
      onWillPop: () async {
        if (linkWithPhone) {
          await logout();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: linkWithPhone
              ? CustomBackButton(
                  onPressed: () async => await logout(), padding: 3)
              : const RegularBackButton(padding: 0),
          elevation: 0,
          scrolledUnderElevation: 5,
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
                    lottieAssetAnim,
                    fit: BoxFit.contain,
                    height: screenHeight * 0.4,
                  ),
                  AutoSizeText(
                    title,
                    style: GoogleFonts.montserrat(
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
                  inputType == InputType.phone
                      ? IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: textFormTitle,
                            hintText: textFormHint,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'EG',
                          onChanged: (phone) {
                            OtpVerificationController
                                .instance
                                .phoneTextController
                                .text = phone.completeNumber;
                          },
                        )
                      : TextFormFieldRegular(
                          labelText: textFormTitle,
                          hintText: textFormHint,
                          prefixIconData: prefixIconData,
                          textController:
                              ResetController.instance.emailController,
                          inputType: inputType,
                          editable: true,
                          textInputAction: TextInputAction.done,
                        ),
                  const SizedBox(height: 20.0),
                  RegularElevatedButton(
                    buttonText: buttonTitle,
                    enabled: true,
                    onPressed: () async {
                      if (inputType == InputType.phone) {
                        await OtpVerificationController.instance
                            .otpOnClick(linkWithPhone: linkWithPhone);
                      } else {
                        final controller = ResetController.instance;
                        await controller.resetPassword(
                            controller.emailController.value.text.trim());
                      }
                    },
                    color: Colors.black,
                  ),
                  inputType == InputType.phone && !linkWithPhone
                      ? AlternateLoginButtons(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          showPhoneLogin: false,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
