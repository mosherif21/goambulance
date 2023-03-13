import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/features/authentication/controllers/otp_verification_controller.dart';
import 'package:goambulance/src/general/common_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/app_init_constants.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({
    Key? key,
    required this.verificationType,
    required this.lottieAssetAnim,
    required this.enteredString,
    required this.inputType,
  }) : super(key: key);
  final String verificationType;
  final String lottieAssetAnim;
  final String enteredString;
  final InputType inputType;

  @override
  Widget build(BuildContext context) {
    double? screenHeight = getScreenHeight(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPaddingSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAssetAnim,
              fit: BoxFit.contain,
              height: screenHeight * 0.5,
            ),
            Text(
              AppInit.currentDeviceLanguage == Language.english
                  ? '$verificationType ${'verificationCode'.tr}'
                  : '${'verificationCode'.tr} $verificationType',
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: AppInit.notWebMobile ? 25 : 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              enteredString,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'verificationCodeShare'.tr,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600),
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
                  inputType: inputType,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
