import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_bottom_sheet.dart';
import 'package:goambulance/src/connectivity/connectivity.dart';
import 'package:goambulance/src/features/onboarding/components/on_boarding_next_button.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../localization/language/language_functions.dart';
import '../../../constants/app_init_constants.dart';
import '../../../routing/splash_screen.dart';
import '../../login/components/language_select.dart';
import '../../login/screens/login_screen.dart';
import '../components/models.dart';
import '../components/onboarding_shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(context, 0, false);
    final LiquidController obController = LiquidController();
    RxInt currentPageCounter = 0.obs;
    const bool mounted = true;
    if (AppInit.showOnBoard) removeSplashScreen();
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
              onPress: () {
                obController.animateToPage(
                    page: obController.currentPage + 1, duration: 500);
                if (currentPageCounter.value == numberOfPages) {
                  RegularBottomSheet(
                    context: context,
                    child: LogInLanguageSelect(
                      onEnglishLanguagePress: () async {
                        await setShowOnBoarding();
                        Get.updateLocale(const Locale('en', 'US'));
                        await setLocale('en');
                        if (mounted) Navigator.pop(context);
                        Get.offAll(() => const LoginScreen());
                      },
                      onArabicLanguagePress: () async {
                        await setShowOnBoarding();
                        Get.updateLocale(const Locale('ar', 'SA'));
                        await setLocale('ar');
                        if (mounted) Navigator.pop(context);
                        Get.offAll(() => const LoginScreen());
                      },
                    ),
                  ).showRegularBottomSheet();
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
