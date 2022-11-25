import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:lottie/lottie.dart';

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
    final double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(kDefaultPaddingSize),
      color: onBoardingBackGroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Lottie.asset(onBoardingAnim,
              height: height * 0.5, frameRate: FrameRate.max),
          Column(
            children: [
              Text(
                onBoardingTitle,
                style: TextStyle(color: titleTextColor, fontSize: 25.0),
              ),
              const SizedBox(height: 5.0),
              Text(
                onBoardingSubTitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: titleSubTextColor),
              ),
            ],
          ),
          const SizedBox(height: 80.0)
        ],
      ),
    );
  }
}
