import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/authentication/controllers/otp_verification_controller.dart';
import 'package:goambulance/src/general/common_functions.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
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
    required this.onPressed,
    required this.textController,
    required this.inputType,
  }) : super(key: key);
  final String title;
  final String lottieAssetAnim;
  final String textFormTitle;
  final String textFormHint;
  final String buttonTitle;
  final IconData prefixIconData;
  final Function onPressed;
  final InputType inputType;

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
    Widget entryScreenWidget;
    var screenType = AppInit.getScreenSize(screenWidth);
    switch (screenType) {
      case ScreenSize.small:
        entryScreenWidget = entryScreenSmall(
            screenHeight: screenHeight, screenWidth: screenWidth);
        break;
      case ScreenSize.medium:
      case ScreenSize.large:
        entryScreenWidget = entryScreenLarge(
            screenHeight: screenHeight, screenWidth: screenWidth);
        break;
    }
    return WillPopScope(
      onWillPop: () async {
        if (inputType == InputType.phone &&
            Get.isRegistered<OtpVerificationController>()) {
          Get.delete<OtpVerificationController>();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: screenType == ScreenSize.small
            ? Colors.white
            : Colors.grey.shade100,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPaddingSize),
            child: entryScreenWidget,
          ),
        ),
      ),
    );
  }

  Widget entryScreenSmall(
      {required double screenHeight, required double screenWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          lottieAssetAnim,
          height: screenHeight * 0.5,
        ),
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: AppInit.notWebMobile ? 25 : 14,
            fontWeight: FontWeight.w700,
          ),
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
                  textController.text = phone.completeNumber;
                },
              )
            : TextFormFieldRegular(
                labelText: textFormTitle,
                hintText: textFormHint,
                prefixIconData: prefixIconData,
                textController: textController,
                inputType: inputType,
              ),
        const SizedBox(height: 20.0),
        RegularElevatedButton(
            buttonText: buttonTitle, enabled: true, onPressed: onPressed),
        inputType == InputType.phone
            ? const SizedBox(height: 10.0)
            : const SizedBox(),
        inputType == InputType.phone
            ? AlternateLoginButtons(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                showPhoneLogin: false,
              )
            : const SizedBox(),
      ],
    );
  }

  Widget entryScreenLarge(
      {required double screenHeight, required double screenWidth}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Lottie.asset(
            lottieAssetAnim,
            width: double.infinity,
            height: screenHeight * 0.75,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 5.0)],
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: AppInit.notWebMobile ? 25 : 14,
                    fontWeight: FontWeight.w700,
                  ),
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
                          textController.text = phone.completeNumber;
                        },
                      )
                    : TextFormFieldRegular(
                        labelText: textFormTitle,
                        hintText: textFormHint,
                        prefixIconData: prefixIconData,
                        textController: textController,
                        inputType: inputType,
                      ),
                const SizedBox(height: 20.0),
                RegularElevatedButton(
                    buttonText: buttonTitle,
                    enabled: true,
                    onPressed: onPressed),
                inputType == InputType.phone
                    ? Column(
                        children: [
                          const SizedBox(height: 10.0),
                          AlternateLoginButtons(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            showPhoneLogin: false,
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
