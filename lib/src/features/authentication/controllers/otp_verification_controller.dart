import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';

import '../../../constants/app_init_constants.dart';
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
    required bool goToInitPage,
  }) async {
    showLoadingScreen();
    String returnMessage = '';
    if (linkWithPhone) {
      returnMessage =
          await authenticationRepository.linkPhoneCredentialWithAccount(
              otp: verificationCode, goToInitPage: goToInitPage);
    } else {
      returnMessage =
          await authenticationRepository.signInVerifyOTP(otp: verificationCode);
    }
    if (returnMessage == 'success') {
      hideLoadingScreen();
      if (goToInitPage) {
        AppInit.goToInitPage();
      } else {
        Get.close(2);
        showSnackBar(
          text: 'phoneChangeSuccess'.tr,
          snackBarType: SnackBarType.success,
        );
      }
    } else {
      hideLoadingScreen();
      showSnackBar(
        text: returnMessage,
        snackBarType: SnackBarType.error,
      );
    }
  }

  Future<void> otpOnClick(
      {required bool linkWithPhone, required bool goToInitPage}) async {
    String phoneNumber = phoneTextController.value.text.trim();

    if (linkWithPhone && !goToInitPage) {
      print(phoneNumber);
      print(authenticationRepository.fireUser.value!.phoneNumber);
      if (phoneNumber == authenticationRepository.fireUser.value!.phoneNumber) {
        showSnackBar(
          text: 'phoneNumberAlreadyYourAccount'.tr,
          snackBarType: SnackBarType.error,
        );
        return;
      }
    }
    String returnMessage = '';
    FocusManager.instance.primaryFocus?.unfocus();
    showLoadingScreen();
    if (phoneNumber.length == 13 && phoneNumber.isPhoneNumber) {
      returnMessage = await authenticationRepository.signInWithPhoneNumber(
          phoneNumber: phoneNumber, linkWithPhone: linkWithPhone);
    } else {
      returnMessage = 'invalidPhoneNumber'.tr;
    }
    hideLoadingScreen();
    if (returnMessage == 'codeSent') {
      await Get.to(
        () => OTPVerificationScreen(
          verificationType: 'phoneLabel'.tr,
          lottieAssetAnim: kPhoneOTPAnim,
          enteredString: phoneNumber,
          linkWithPhone: linkWithPhone,
          goToInitPage: goToInitPage,
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
