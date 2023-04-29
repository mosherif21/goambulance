import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/general_functions.dart';
import 'add_disease.dart';

class NoMedicalHistory extends StatelessWidget {
  const NoMedicalHistory({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final dynamic controller;
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
            const SizedBox(height: 10),
            AutoSizeText(
              'noMedicalHistory'.tr,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: RegularElevatedButton(
                buttonText: 'addAllergiesOrDiseases'.tr,
                onPressed: () => RegularBottomSheet.showRegularBottomSheet(
                  AddDisease(controller: controller),
                ),
                enabled: true,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
