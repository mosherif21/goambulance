import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/authentication/controllers/otp_verification_controller.dart';
import 'package:goambulance/src/features/authentication/controllers/reset_password_controller.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';

import '../../constants/enums.dart';
import '../../constants/sizes.dart';
import '../../features/authentication/components/generalAuthComponents/alternate_login_buttons.dart';
import '../app_init.dart';

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
    required this.goToInitPage,
    this.validationFunction,
  }) : super(key: key);
  final String title;
  final String lottieAssetAnim;
  final String textFormTitle;
  final String textFormHint;
  final String buttonTitle;
  final IconData prefixIconData;
  final InputType inputType;
  final bool linkWithPhone;
  final bool goToInitPage;
  final String? Function(String?)? validationFunction;

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
    if (inputType == InputType.phone) {
      Get.put(OtpVerificationController());
    } else if (inputType == InputType.email) {
      Get.put(ResetPasswordController());
    }
    return WillPopScope(
      onWillPop: () async {
        if (linkWithPhone && goToInitPage) {
          logoutDialogue();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: linkWithPhone && goToInitPage
              ? CustomBackButton(onPressed: () => logoutDialogue(), padding: 3)
              : const RegularBackButton(padding: 0),
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
                    lottieAssetAnim,
                    fit: BoxFit.contain,
                    height: screenHeight * 0.4,
                  ),
                  AutoSizeText(
                    title,
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
                          countries: const [
                            Country(
                              name: "Egypt",
                              nameTranslations: {
                                "sk": "Egypt",
                                "se": "Egypt",
                                "pl": "Egipt",
                                "no": "Egypt",
                                "ja": "エジプト",
                                "it": "Egitto",
                                "zh": "埃及",
                                "nl": "Egypt",
                                "de": "Ägypt",
                                "fr": "Égypte",
                                "es": "Egipt",
                                "en": "Egypt",
                                "pt_BR": "Egito",
                                "sr-Cyrl": "Египат",
                                "sr-Latn": "Egipat",
                                "zh_TW": "埃及",
                                "tr": "Mısır",
                                "ro": "Egipt",
                                "ar": "مصر",
                                "fa": "مصر",
                                "yue": "埃及"
                              },
                              flag: "🇪🇬",
                              code: "EG",
                              dialCode: "20",
                              minLength: 10,
                              maxLength: 10,
                            ),
                          ],
                          pickerDialogStyle: PickerDialogStyle(
                            searchFieldInputDecoration:
                                InputDecoration(hintText: 'searchCountry'.tr),
                          ),
                          onChanged: (phone) {
                            OtpVerificationController
                                .instance
                                .phoneTextController
                                .text = phone.completeNumber;
                          },
                        )
                      : Form(
                          key: ResetPasswordController.instance.formKey,
                          child: TextFormFieldRegular(
                            labelText: textFormTitle,
                            hintText: textFormHint,
                            prefixIconData: prefixIconData,
                            textController: ResetPasswordController
                                .instance.emailController,
                            inputType: inputType,
                            editable: true,
                            textInputAction: TextInputAction.done,
                            validationFunction: validationFunction,
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  RegularElevatedButton(
                    buttonText: buttonTitle,
                    enabled: true,
                    onPressed: () {
                      if (inputType == InputType.phone) {
                        OtpVerificationController.instance.otpOnClick(
                            linkWithPhone: linkWithPhone,
                            goToInitPage: goToInitPage);
                      } else {
                        final controller = ResetPasswordController.instance;
                        controller.resetPassword();
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
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
