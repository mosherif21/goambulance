import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/rounded_elevated_button.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/text_header.dart';
import '../../../../../general/general_functions.dart';

class EmployeeHospitalGetFailed extends StatelessWidget {
  const EmployeeHospitalGetFailed({super.key, required this.onTryAgainPressed});
  final Function onTryAgainPressed;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            kNoInternetSwitchAnim,
            fit: BoxFit.contain,
            height: screenHeight * 0.4,
          ),
          TextHeader(
            headerText: 'failedToGetHospital'.tr,
            fontSize: 20,
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          RoundedElevatedButton(
            buttonText: 'tryAgain'.tr,
            onPressed: () => onTryAgainPressed(),
            enabled: true,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
