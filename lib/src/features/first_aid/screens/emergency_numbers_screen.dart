import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/general_functions.dart';

import '../../../general/common_widgets/back_button.dart';
import '../../../general/common_widgets/regular_clickable_card.dart';
import '../controllers/first_aid_assets.dart';

class EmergencyNumbersScreen extends StatelessWidget {
  const EmergencyNumbersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'emergencyNumbers'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int emergencyNumber) {
                  return AnimationConfiguration.staggeredList(
                    position: emergencyNumber,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: RegularClickableCard(
                          onPressed: () => callNumber(
                              phoneNumber: emergencyNumbers[emergencyNumber]),
                          title: 'emergencyNumber${emergencyNumber + 1}'.tr,
                          subTitle: emergencyNumbers[emergencyNumber],
                          icon: Icons.call,
                          iconColor: Colors.green,
                          imgPath: getEmergencyNumberImage(emergencyNumber + 1),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: emergencyNumbers.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
