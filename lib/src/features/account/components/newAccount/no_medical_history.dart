import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../general/general_functions.dart';

class NoMedicalHistory extends StatelessWidget {
  const NoMedicalHistory({
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
            SvgPicture.asset(
              kMedicalHistoryImg,
              height: screenHeight * 0.25,
            ),
            SizedBox(height: screenHeight * 0.02),
            AutoSizeText(
              'noMedicalHistory'.tr,
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
