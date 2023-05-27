import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';

class EmptyRequestsHistory extends StatelessWidget {
  const EmptyRequestsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            kNoRequestsHistory,
            fit: BoxFit.contain,
            height: screenHeight * 0.4,
          ),
          AutoSizeText(
            'noRequests'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
