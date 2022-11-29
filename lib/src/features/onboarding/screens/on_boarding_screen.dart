import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_bottom_sheet.dart';
import 'package:goambulance/src/connectivity/connectivity.dart';
import 'package:goambulance/src/features/onboarding/components/on_boarding_next_button.dart';
import 'package:goambulance/src/routing/loading_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../localization/language/language_functions.dart';
import '../../login/components/language_select.dart';
import '../../login/screens/login_screen.dart';
import '../components/liquid_swipe.dart';
import '../components/models.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    ConnectivityChecker.checkConnection(context, 0, false);
    const bool mounted = true;

    Future<void> setLocaleLanguage(String languageCode) async {
      showLoadingScreen(context, screenHeight);
      await setOnBoardingLocale(languageCode);
      Future.delayed(
        const Duration(seconds: 1),
        () {
          if (mounted) hideLoadingScreen(context);
          if (mounted) Navigator.pop(context);
          Get.offAll(() => const LoginScreen());
        },
      );
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const LiquidSwipeWidget(),
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
            bottom: 50,
            child: OnBoardingPageNextButton(
              onPress: () {
                obController.animateToPage(
                    page: obController.currentPage + 1, duration: 500);
                if (currentPageCounter.value == numberOfPages) {
                  RegularBottomSheet(
                    context: context,
                    child: LogInLanguageSelect(
                      onEnglishLanguagePress: () async {
                        await setLocaleLanguage('en');
                      },
                      onArabicLanguagePress: () async {
                        await setLocaleLanguage('ar');
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
