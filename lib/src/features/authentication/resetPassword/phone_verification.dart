import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/text_form_field.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/constants/common_functions.dart';
import 'package:goambulance/src/features/authentication/resetPassword/otp_verification.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/sizes.dart';

class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenHeight = getScreenHeight(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPaddingSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              kPhoneVerificationAnim,
              height: screenHeight * 0.5,
            ),
            Text(
              'phoneVerification'.tr,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormFieldRegular(
              labelText: 'phoneLabel'.tr,
              hintText: 'phoneFieldLabel'.tr,
              prefixIconData: Icons.phone,
              color: Colors.black,
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                ),
                onPressed: () => Get.to(
                  () => OTPVerificationScreen(
                    verificationType: 'phoneLabel'.tr,
                    lottieAssetAnim: kPhoneOTPAnim,
                  ),
                ),
                child: Text(
                  'continue'.tr,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
