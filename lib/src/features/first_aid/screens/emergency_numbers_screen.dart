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
        child: Padding(
          padding: const EdgeInsets.only(
              top: 5.0, bottom: 20.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RegularBackButton(padding: 0),
              Text(
                'emergencyNumbers'.tr,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int emergencyNumber) {
                    return RegularClickableCard(
                      onPressed: () async =>
                          await FlutterPhoneDirectCaller.callNumber(
                              emergencyNumbers[emergencyNumber]),
                      title: 'emergencyNumber${emergencyNumber + 1}'.tr,
                      subTitle: emergencyNumbers[emergencyNumber],
                      icon: Icons.call,
                      iconColor: Colors.green,
                      imgPath: getEmergencyNumberImage(emergencyNumber + 1),
                    );
                  },
                  itemCount: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
