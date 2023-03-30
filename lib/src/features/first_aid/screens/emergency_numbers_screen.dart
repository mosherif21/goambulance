import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';

import '../../../general/common_functions.dart';
import '../../../general/common_widgets/back_button.dart';
import '../../../general/common_widgets/regular_clickable_card.dart';
import '../controllers/first_aid_assets.dart';

class EmergencyNumbersScreen extends StatelessWidget {
  const EmergencyNumbersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RegularBackButton(),
                Text(
                  'emergencyNumbers'.tr,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                for (int emergencyNumber = 1;
                    emergencyNumber <= 6;
                    emergencyNumber++)
                  RegularClickableCard(
                    onPressed: () async =>
                        await FlutterPhoneDirectCaller.callNumber(
                            emergencyNumbers[emergencyNumber - 1]),
                    title: 'emergencyNumber$emergencyNumber'.tr,
                    subTitle: emergencyNumbers[emergencyNumber - 1],
                    icon: Icons.call,
                    iconColor: Colors.green,
                    imgPath: getEmergencyNumberImage(emergencyNumber),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
