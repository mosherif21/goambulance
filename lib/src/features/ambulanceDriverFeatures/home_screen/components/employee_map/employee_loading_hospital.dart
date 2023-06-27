import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/text_header.dart';
import '../../../../../general/general_functions.dart';

class EmployeeLoadingHospital extends StatelessWidget {
  const EmployeeLoadingHospital({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            kLoadingHospitalAnim,
            fit: BoxFit.contain,
            height: screenHeight * 0.4,
          ),
          TextHeader(
              headerText: 'loadingHospitalInfo'.tr, fontSize: 20, maxLines: 1)
        ],
      ),
    );
  }
}
