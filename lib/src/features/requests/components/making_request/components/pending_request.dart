import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/general_functions.dart';

class PendingRequest extends StatelessWidget {
  const PendingRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return SizedBox(
      height: screenHeight * 0.25,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset(
              kPendingRequestAnim,
              height: screenHeight * 0.2,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AutoSizeText(
                'waitingForAcceptance'.tr,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
