import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showLoadingScreen() {
  final height = Get.context?.height;

  Get.dialog(
    AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: WillPopScope(
        onWillPop: () async => false,
        child: SizedBox(
          height: AppInit.notWebMobile ? 812.0 : double.infinity,
          width: AppInit.notWebMobile ? 500.0 : double.infinity,
          child: LoadingAnimationWidget.inkDrop(
            color: Colors.white,
            size: height! * 0.08,
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void hideLoadingScreen() {
  Get.back();
}
