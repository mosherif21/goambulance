import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:lottie/lottie.dart';

class NotInternetErrorWidget extends StatelessWidget {
  const NotInternetErrorWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = getScreenHeight(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(kDefaultPaddingSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Lottie.asset(
                    kNoInternetSwitchAnim,
                    fit: BoxFit.contain,
                    height: height * 0.5,
                  ),
                  Column(
                    children: [
                      AutoSizeText(
                        'noConnectionAlertTitle'.tr,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5.0),
                      AutoSizeText(
                        'noConnectionAlertContent'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
