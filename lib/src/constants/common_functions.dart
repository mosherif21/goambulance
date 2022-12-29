import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../features/home_page/screens/home_page_screen.dart';

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

void getToHomePage() {
  Get.offAll(() => const HomePageScreen());
}

void showSimpleSnackBar(
    String title, String body, SnackPosition position, Color textColor) {
  Get.snackbar(title, body,
      colorText: textColor,
      snackPosition: position,
      margin: const EdgeInsets.all(20.0));
}
