import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/assets_strings.dart';
import 'on_boarding_page_widget.dart';

final pages = [
  OnBoardingPageTemplate(
    onBoardingBackGroundColor: Colors.white,
    onBoardingAnim: kOnBoardingAnim1,
    onBoardingTitle: 'onBoardingTitle1'.tr,
    onBoardingSubTitle: 'onBoardingSubTitle1'.tr,
    titleTextColor: Colors.black,
    titleSubTextColor: Colors.black87,
  ),
  OnBoardingPageTemplate(
    onBoardingBackGroundColor: Colors.blue,
    onBoardingAnim: kOnBoardingAnim2,
    onBoardingTitle: 'onBoardingTitle2'.tr,
    onBoardingSubTitle: 'onBoardingSubTitle2'.tr,
    titleTextColor: Colors.white,
    titleSubTextColor: Colors.white70,
  ),
  OnBoardingPageTemplate(
    onBoardingBackGroundColor: Colors.yellow,
    onBoardingAnim: kOnBoardingAnim3,
    onBoardingTitle: 'onBoardingTitle3'.tr,
    onBoardingSubTitle: 'onBoardingSubTitle3'.tr,
    titleTextColor: Colors.black,
    titleSubTextColor: Colors.black87,
  ),
];
final int numberOfPages = pages.length - 1;
