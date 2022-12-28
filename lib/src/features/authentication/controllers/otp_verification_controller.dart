import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/common_functions.dart';

import '../../../constants/app_init_constants.dart';
import '../../../general/loading_screen.dart';

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
    hideLoadingScreen();

    return returnMessage;
  }

  Future<String> verifyOTPPhone(String otp) async {
    var returnMessage = await AuthenticationRepository.instance.verifyOTP(otp);
    return returnMessage;
  }

  Future<String> verifyOTPEmail(String otp) async {
    var returnMessage = await AuthenticationRepository.instance.verifyOTP(otp);
    return returnMessage;
  }

  Future<void> verifyOTP({
    required String verificationCode,
    required InputType inputType,
  }) async {
    showLoadingScreen();
    var returnMessage = inputType == InputType.phone
        ? await verifyOTPPhone(verificationCode)
        : await verifyOTPEmail(verificationCode);
    hideLoadingScreen();
    if (returnMessage.compareTo('success') == 0) {
      getToHomePage();
    } else {
      Get.snackbar(
        'error'.tr,
        returnMessage,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20.0),
      );
    }
  }
}
