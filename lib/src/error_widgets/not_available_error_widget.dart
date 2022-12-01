import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/constants/common_functions.dart';
import 'package:goambulance/src/constants/sizes.dart';

class NotAvailableErrorWidget extends StatelessWidget {
  const NotAvailableErrorWidget({Key? key}) : super(key: key);

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
                kNotAvailableErrorAnim,
                height: height * 0.5,
              ),
              Column(
                children: [
                  Text(
                    'notAvailableErrorTitle'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'notAvailableErrorSubTitle'.tr,
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
