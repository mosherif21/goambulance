import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/intro_screen/controllers/onBoarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../general/common_widgets/language_select.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../components/liquid_swipe.dart';
import '../components/on_boarding_next_button.dart';
import '../components/onboarding_shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final obController = Get.put(OnBoardingController());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            LiquidSwipeWidget(obController: obController),
            Obx(
              () => obController.currentPageCounter.value !=
                      obController.numberOfPages
                  ? Positioned(
                      top: 50,
                      right: 30,
                      child: TextButton(
                        onPressed: () => obController.liquidSwipeController
                            .jumpToPage(page: obController.numberOfPages),
                        child: Text(
                          'skipLabel'.tr,
                          style: TextStyle(
                            color: obController.currentPageCounter.value == 0
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
                onPress: () async {
                  obController.liquidSwipeController.animateToPage(
                      page: obController.liquidSwipeController.currentPage + 1,
                      duration: 500);
                  if (obController.currentPageCounter.value ==
                      obController.numberOfPages) {
                    await RegularBottomSheet.showRegularBottomSheet(
                      LanguageSelect(
                        onEnglishLanguagePress: () async {
                          await setOnBoardingLocaleLanguage(
                            'en',
                          );
                        },
                        onArabicLanguagePress: () async {
                          await setOnBoardingLocaleLanguage(
                            'ar',
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Obx(
              () => Positioned(
                bottom: 15,
                child: AnimatedSmoothIndicator(
                  activeIndex: obController.currentPageCounter.value,
                  count: obController.numberOfPages + 1,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.black,
                    dotHeight: 10.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
