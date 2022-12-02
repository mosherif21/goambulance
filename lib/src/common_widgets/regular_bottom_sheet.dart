import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegularBottomSheet {
  static Future<void> showRegularBottomSheet(Widget child) async {
    await Get.bottomSheet(
      Wrap(
        children: [child],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }

  static void hideBottomSheet() {
    if (Get.isBottomSheetOpen!) Get.back();
  }
}
