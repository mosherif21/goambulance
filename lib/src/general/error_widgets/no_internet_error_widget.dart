import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/general/common_functions.dart';

class NotInternetErrorWidget extends StatelessWidget {
  const NotInternetErrorWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = getScreenHeight(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(kDefaultPaddingSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                kNoInternetSwitchAnim,
                height: height * 0.5,
              ),
              Column(
                children: [
                  Text(
                    'noConnectionAlertTitle'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'noConnectionAlertContent'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
