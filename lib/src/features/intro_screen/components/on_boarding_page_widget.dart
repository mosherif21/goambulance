import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:lottie/lottie.dart';

import '../../../general/general_functions.dart';

class OnBoardingPageTemplate extends StatelessWidget {
  const OnBoardingPageTemplate({
    Key? key,
    required this.onBoardingAnim,
    required this.onBoardingTitle,
    required this.onBoardingSubTitle,
    required this.onBoardingBackGroundColor,
    required this.titleTextColor,
    required this.titleSubTextColor,
  }) : super(key: key);

  final Color onBoardingBackGroundColor;
  final String onBoardingAnim;
  final String onBoardingTitle;
  final String onBoardingSubTitle;
  final Color titleTextColor;
  final Color titleSubTextColor;
  @override
  Widget build(BuildContext context) {
    final double height = getScreenHeight(context);
    final double width = getScreenWidth(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kDefaultPaddingSize),
      color: onBoardingBackGroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Lottie.asset(onBoardingAnim,
              fit: BoxFit.contain, height: height * 0.5, width: width * 0.8),
          Column(
            children: [
              AutoSizeText(
                onBoardingTitle,
                style: TextStyle(color: titleTextColor, fontSize: 25.0),
                maxLines: 1,
              ),
              const SizedBox(height: 5.0),
              AutoSizeText(
                onBoardingSubTitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: titleSubTextColor),
                maxLines: 2,
              ),
            ],
          ),
          const SizedBox(height: 80.0)
        ],
      ),
    );
  }
}
