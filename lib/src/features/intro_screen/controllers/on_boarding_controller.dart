import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

import '../../../constants/assets_strings.dart';
import '../components/on_boarding_page_widget.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final LiquidController liquidSwipeController = LiquidController();
  RxInt currentPageCounter = 0.obs;

  static List<OnBoardingPageTemplate> pages = [
    OnBoardingPageTemplate(
      onBoardingBackGroundColor: Colors.white,
      onBoardingAnim: kAmbulanceCarAnim,
      onBoardingTitle: 'onBoardingTitle1'.tr,
      onBoardingSubTitle: 'onBoardingSubTitle1'.tr,
      titleTextColor: Colors.black,
      titleSubTextColor: Colors.black87,
    ),
    OnBoardingPageTemplate(
      onBoardingBackGroundColor: Colors.blue,
      onBoardingAnim: kCustomerServiceAnim,
      onBoardingTitle: 'onBoardingTitle2'.tr,
      onBoardingSubTitle: 'onBoardingSubTitle2'.tr,
      titleTextColor: Colors.white,
      titleSubTextColor: Colors.white70,
    ),
    OnBoardingPageTemplate(
      onBoardingBackGroundColor: Colors.yellow,
      onBoardingAnim: kLocationPinOnMapAnim,
      onBoardingTitle: 'onBoardingTitle3'.tr,
      onBoardingSubTitle: 'onBoardingSubTitle3'.tr,
      titleTextColor: Colors.black,
      titleSubTextColor: Colors.black87,
    ),
  ];
  final int numberOfPages = pages.length - 1;
}
