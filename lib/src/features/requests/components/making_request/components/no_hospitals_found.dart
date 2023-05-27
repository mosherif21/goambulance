import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/general_functions.dart';

class NoHospitalsFound extends StatelessWidget {
  const NoHospitalsFound({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.all(20),
      height: screenHeight * 0.25,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(kHospitalFrontImg),
              height: 120,
            ),
            const SizedBox(height: 10),
            AutoSizeText(
              'noHospitalsFound'.tr,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
