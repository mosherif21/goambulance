import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../constants/assets_strings.dart';
import '../../../constants/enums.dart';
import '../../../general/general_functions.dart';
import '../components/otpVerification/otp_verification.dart';

class OtpVerificationController extends GetxController {
  static OtpVerificationController get instance => Get.find();
  final phoneTextController = TextEditingController();
  final authenticationRepository = AuthenticationRepository.instance;

  Future<void> verifyOTP({
    required String verificationCode,
    required bool linkWithPhone,
  }) async {
    showLoadingScreen();
    String returnMessage = '';
    if (linkWithPhone) {
      returnMessage = await authenticationRepository
          .linkPhoneCredentialWithAccount(otp: verificationCode);
    } else {
      returnMessage =
          await authenticationRepository.signInVerifyOTP(otp: verificationCode);
    }
    if (!returnMessage.contains('success')) {
      hideLoadingScreen();
      showSnackBar(
        text: returnMessage,
        snackBarType: SnackBarType.error,
      );
    }
  }

  Future<void> otpOnClick({required bool linkWithPhone}) async {
    String phoneNumber = phoneTextController.value.text.trim();
    String returnMessage = '';
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    if (phoneNumber.length == 13 && phoneNumber.isPhoneNumber) {
      returnMessage = await authenticationRepository.signInWithPhoneNumber(
          phoneNumber: phoneNumber, linkWithPhone: false);
    } else {
      returnMessage = 'invalidPhoneNumber'.tr;
    }
    hideLoadingScreen();
    if (returnMessage.contains('codeSent')) {
      await Get.to(
        () => OTPVerificationScreen(
          verificationType: 'phoneLabel'.tr,
          lottieAssetAnim: kPhoneOTPAnim,
          enteredString: phoneNumber,
          linkWithPhone: linkWithPhone,
        ),
        transition: getPageTransition(),
      );
    } else {
      showSnackBar(
        text: returnMessage,
        snackBarType: SnackBarType.error,
      );
    }
  }

  @override
  void onClose() {
    phoneTextController.dispose();
    super.onClose();
  }
}
