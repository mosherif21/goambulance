import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/screens/home_screen.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../../constants/app_init_constants.dart';
import '../../../../constants/colors.dart';
import '../../../../general/common_widgets/regular_card.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';

class MedicalHistoryInsertPage extends StatelessWidget {
  const MedicalHistoryInsertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final controller = RegisterUserDataController.instance;
    //final screenHeight = getScreenHeight(context);
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
                      RegularCard(
                        child: RegularElevatedButton(
                          buttonText: 'save'.tr,
                          onPressed: () async {
                            //await Get.delete<RegisterUserDataController>();
                            Get.offAll(() => const HomeScreen(),
                                transition: AppInit.getPageTransition());
                          },
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
