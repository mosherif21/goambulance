import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/assets_strings.dart';
import '../../../general/common_widgets/back_button.dart';
import '../../../general/common_widgets/rounded_image_button.dart';
import '../../../general/general_functions.dart';
import '../../first_aid/screens/emergency_numbers_screen.dart';
import '../../home_screen/controllers/home_screen_controller.dart';
import '../../requests/components/making_request/normal_request_screen.dart';
import '../../sos_message/screens/sos_message_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'services'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: RoundedImageElevatedButton(
                          buttonText: 'normalRequest'.tr,
                          imagePath: kAmbulanceImage,
                          onPressed: () => Get.to(
                            () => const NormalRequestScreen(),
                            transition: getPageTransition(),
                          ),
                        ),
                      ),
                      const Spacer(),
                      isUserCritical()
                          ? Expanded(
                              flex: 8,
                              child: RoundedImageElevatedButton(
                                buttonText: 'sosRequest'.tr,
                                imagePath: kSosImage,
                                onPressed: () => HomeScreenController.instance
                                    .sosRequestPress(),
                              ),
                            )
                          : Expanded(
                              flex: 8,
                              child: RoundedImageElevatedButton(
                                buttonText: 'sosMessage'.tr,
                                imagePath: kSosMessageImage,
                                onPressed: () => Get.to(
                                  () => const SosMessageScreen(),
                                  transition: getPageTransition(),
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (isUserCritical())
                        Expanded(
                          flex: 8,
                          child: RoundedImageElevatedButton(
                            buttonText: 'sosMessage'.tr,
                            imagePath: kSosMessageImage,
                            onPressed: () => Get.to(
                              () => const SosMessageScreen(),
                              transition: getPageTransition(),
                            ),
                          ),
                        ),
                      if (isUserCritical()) const Spacer(),
                      Expanded(
                        flex: 8,
                        child: RoundedImageElevatedButton(
                          buttonText: 'emergencyNumbers'.tr,
                          imagePath: kEmergencyNumber,
                          onPressed: () => Get.to(
                            () => const EmergencyNumbersScreen(),
                            transition: getPageTransition(),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
