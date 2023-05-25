import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/authentication/controllers/otp_verification_controller.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../general/app_init.dart';
import '../../../../general/common_widgets/back_button.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({
    Key? key,
    required this.verificationType,
    required this.lottieAssetAnim,
    required this.enteredString,
    required this.linkWithPhone,
    required this.goToInitPage,
  }) : super(key: key);
  final String verificationType;
  final String lottieAssetAnim;
  final String enteredString;
  final bool linkWithPhone;
  final bool goToInitPage;

  @override
  Widget build(BuildContext context) {
    double? screenHeight = getScreenHeight(context);
    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        elevation: 0,
        scrolledUnderElevation: 5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Lottie.asset(
                    lottieAssetAnim,
                    fit: BoxFit.contain,
                    height: screenHeight * 0.4,
                  ),
                  AutoSizeText(
                    isLangEnglish()
                        ? '$verificationType ${'verificationCode'.tr}'
                        : '${'verificationCode'.tr} $verificationType',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: AppInit.notWebMobile ? 25 : 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    minFontSize: 10,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AutoSizeText(
                    enteredString,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    minFontSize: 10,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AutoSizeText(
                    'verificationCodeShare'.tr,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                    maxLines: 2,
                    minFontSize: 10,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: Colors.black54,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    focusedBorderColor: Colors.black,
                    showFieldAsBox: false,
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600),
                    borderWidth: 4.0,
                    onSubmit: (enteredVerificationCode) async {
                      await OtpVerificationController.instance.verifyOTP(
                        verificationCode: enteredVerificationCode,
                        linkWithPhone: linkWithPhone,
                        goToInitPage: goToInitPage,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
