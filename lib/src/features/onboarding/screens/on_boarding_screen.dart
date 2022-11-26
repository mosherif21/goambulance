import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/login/screens/login_screen.dart';
import 'package:goambulance/src/features/onboarding/components/on_boarding_next_button.dart';
import 'package:goambulance/src/features/onboarding/components/onboarding_shared_preferences.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../connectivity/connectivity_controller.dart';
import '../components/models.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    FlutterNativeSplash.remove();

    final ConnectivityController connectivityController =
        Get.find<ConnectivityController>();
    connectivityController.updateContext(context, height, false);

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
              slideIconWidget: currentPageCounter.value != numberOfPages
                  ? const Icon(Icons.arrow_back_ios)
                  : null,
              enableSideReveal: true,
              enableLoop: false,
            ),
          ),
          Obx(
            () => currentPageCounter.value != numberOfPages
                ? Positioned(
                    top: 50,
                    right: 30,
                    child: TextButton(
                      onPressed: () =>
                          obController.jumpToPage(page: numberOfPages),
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
                if (currentPageCounter.value == numberOfPages) {
                  await setShowOnBoarding();
                  Get.offAll(() => const LoginScreen());
                }
              },
            ),
          ),
          Obx(
            () => Positioned(
              bottom: 15,
              child: AnimatedSmoothIndicator(
                activeIndex: currentPageCounter.value,
                count: numberOfPages + 1,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.black,
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
