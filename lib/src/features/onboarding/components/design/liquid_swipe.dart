import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../models.dart';

final LiquidController obController = LiquidController();
RxInt currentPageCounter = 0.obs;

class LiquidSwipeWidget extends StatelessWidget {
  const LiquidSwipeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LiquidSwipe(
        pages: pages,
        liquidController: obController,
        onPageChangeCallback: (activeIndex) =>
            currentPageCounter.value = activeIndex,
        slideIconWidget: currentPageCounter.value != numberOfPages
            ? const Icon(Icons.arrow_back_ios)
            : null,
        enableSideReveal: true,
        enableLoop: false,
      ),
    );
  }
}
