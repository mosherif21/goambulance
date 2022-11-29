import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:lottie/lottie.dart';

import '../constants/assets_strings.dart';

void showLoadingScreen(BuildContext context, double height) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: SizedBox(
        height: AppInit.notWebMobile ? 812.0 : double.infinity,
        width: AppInit.notWebMobile ? 500.0 : double.infinity,
        child: Lottie.asset(kLoadingHeartAnim,
            frameRate: FrameRate.max, height: height * 0.3),
      ),
    ),
    barrierDismissible: false,
  );
}

void hideLoadingScreen(BuildContext context) {
  Navigator.pop(context);
}
