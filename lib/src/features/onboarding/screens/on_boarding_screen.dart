import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/onboarding/components/on_boarding_next_button.dart';
import 'package:goambulance/src/features/onboarding/components/onboarding_shared_preferences.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../error_widgets/not_available_error_widget.dart';
import '../components/models.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final LiquidController obController = LiquidController();
    RxInt currentPageCounter = 0.obs;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => LiquidSwipe(
              pages: pages,
              liquidController: obController,
              onPageChangeCallback: (activeIndex) =>
                  currentPageCounter.value = activeIndex,
              slideIconWidget: currentPageCounter.value != numberOfPages - 1
                  ? const Icon(Icons.arrow_back_ios)
                  : null,
              enableSideReveal: true,
              enableLoop: false,
            ),
          ),
          Obx(
            () => currentPageCounter.value != numberOfPages - 1
                ? Positioned(
                    top: 50,
                    right: 30,
                    child: TextButton(
                      onPressed: () =>
                          obController.jumpToPage(page: numberOfPages - 1),
                      child: Text(
                        'skipLabel'.tr,
                        style: TextStyle(
                          color: currentPageCounter.value == 0
                              ? Colors.grey
                              : Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned(
            bottom: 60,
            child: OnBoardingPageNextButton(
              onPress: () async {
                obController.animateToPage(
                    page: obController.currentPage + 1, duration: 500);
                if (currentPageCounter.value == numberOfPages - 1) {
                  await setShowOnBoarding();
                  Get.offAll(() => const NotAvailableErrorWidget());
                }
              },
            ),
          ),
          Obx(
            () => Positioned(
              bottom: 15,
              child: AnimatedSmoothIndicator(
                activeIndex: currentPageCounter.value,
                count: numberOfPages,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color(0xFF272727),
                  dotHeight: 10.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
