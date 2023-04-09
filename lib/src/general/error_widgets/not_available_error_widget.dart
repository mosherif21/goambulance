import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/general/common_functions.dart';

class NotAvailableErrorWidget extends StatelessWidget {
  const NotAvailableErrorWidget({Key? key}) : super(key: key);

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
        ),
      ),
    );
  }
}
