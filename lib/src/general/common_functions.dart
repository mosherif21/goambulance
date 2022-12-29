import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/home_page/screens/home_page_screen.dart';

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

void getToHomePage() {
  Get.offAll(() => HomePageScreen());
}

void showSimpleSnackBar(String title, String body, SnackPosition position) {
  Get.snackbar(title, body,
      colorText: Colors.black,
      snackPosition: position,
      margin: const EdgeInsets.all(20.0));
}
