import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:lottie/lottie.dart';

import '../../../general/general_functions.dart';

class NoNotifications extends StatelessWidget {
  const NoNotifications({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              kNoNotificationsAnim,
              fit: BoxFit.contain,
              height: screenHeight * 0.4,
              repeat: true,
            ),
            SizedBox(height: screenHeight * 0.02),
            AutoSizeText(
              'noNotification'.tr,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
