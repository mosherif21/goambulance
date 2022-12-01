import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RegularBottomSheet {
  final Widget child;
  const RegularBottomSheet({
    required this.child,
  });
  void showRegularBottomSheet() {
    Get.bottomSheet(
      Wrap(
        children: [
          Container(
            child: child,
          )
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
    );
  }

  void hideBottomSheet() {
    if (Get.isBottomSheetOpen == true) Get.back();
  }
}
