import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/general/common_functions.dart';

import '../../../constants/app_init_constants.dart';
import '../../../constants/assets_strings.dart';
import '../components/otpVerification/otp_verification.dart';

class OtpVerificationController extends GetxController {
  static OtpVerificationController get instance => Get.find();
  final enteredData = TextEditingController();

  Future<String> signInWithOTPPhone(String phoneNumber) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    String returnMessage;
    if (phoneNumber.length == 13 && phoneNumber.isPhoneNumber) {
      returnMessage = await AuthenticationRepository.instance
          .signInWithPhoneNumber(phoneNumber);
    } else {
      returnMessage = 'invalidPhoneNumber'.tr;
    }
    return returnMessage;
  }

  Future<void> verifyOTP({
    required String verificationCode,
    required InputType inputType,
  }) async {
    showLoadingScreen();
    var returnMessage =
        await AuthenticationRepository.instance.verifyOTP(verificationCode);
    if (returnMessage.compareTo('success') == 0) {
      if (inputType == InputType.phone &&
          Get.isRegistered<OtpVerificationController>()) {
        await Get.delete<OtpVerificationController>();
      }
    } else {
      hideLoadingScreen();
      showSimpleSnackBar(
        text: returnMessage,
      );
    }
  }

  Future<void> otpOnClick() async {
    var phoneNumber = enteredData.value.text;
    var returnMessage = '';
    returnMessage = await signInWithOTPPhone(phoneNumber);
    hideLoadingScreen();
    if (returnMessage.compareTo('codeSent') == 0) {
      await Get.to(
          () => OTPVerificationScreen(
                inputType: InputType.phone,
                verificationType: 'phoneLabel'.tr,
                lottieAssetAnim: kPhoneOTPAnim,
                enteredString: phoneNumber,
              ),
          transition: AppInit.getPageTransition());
    } else {
      showSimpleSnackBar(
        text: returnMessage,
      );
    }
  }

  @override
  void dispose() {
    enteredData.dispose();
    super.dispose();
  }
}
