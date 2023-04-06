import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../../constants/colors.dart';
import '../../../../general/common_functions.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../controllers/register_user_data_controller.dart';
import 'medical_history_item.dart';

class MedicalHistoryInsertPage extends StatelessWidget {
  const MedicalHistoryInsertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = RegisterUserDataController.instance;
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RegularBackButton(padding: 0),
              const SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5.0),
                      AutoSizeText(
                        'enterMedicalHistory'.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        height: screenHeight * 0.65,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  for (int i = 0; i < 5; i++)
                                    MedicalHistoryItem(
                                      screenHeight: screenHeight,
                                    )
                                ],
                              )

                              //     NoMedicalHistory(
                              //   screenHeight: screenHeight,
                              // ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RegularElevatedButton(
                          buttonText: 'save'.tr,
                          onPressed: () async =>
                              await controller.savePersonalInformation(),
                          enabled: true,
                          color: kDefaultColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
