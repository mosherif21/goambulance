import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/first_aid/components/first_aid_card.dart';

import '../../../general/common_functions.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'firstAid'.tr,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                for (int firstAidNumber = 1;
                    firstAidNumber <= 17;
                    firstAidNumber++)
                  FirstAidCard(firstAidNumber: firstAidNumber),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
