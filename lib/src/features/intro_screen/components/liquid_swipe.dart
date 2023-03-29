import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../controllers/onBoarding_controller.dart';

class LiquidSwipeWidget extends StatelessWidget {
  const LiquidSwipeWidget({Key? key, required this.obController})
      : super(key: key);
  final OnBoardingController obController;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LiquidSwipe(
        pages: OnBoardingController.pages,
        liquidController: obController.liquidSwipeController,
        onPageChangeCallback: (activeIndex) =>
            obController.currentPageCounter.value = activeIndex,
        slideIconWidget:
            obController.currentPageCounter.value != obController.numberOfPages
                ? const Icon(Icons.arrow_back_ios)
                : null,
        enableSideReveal: true,
        enableLoop: false,
      ),
    );
  }
}
