import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/assets_strings.dart';
import '../../../general/common_widgets/rounded_image_button.dart';
import '../../../general/general_functions.dart';
import '../../requests/components/making_request/normal_request_screen.dart';
import '../../sos_message/screens/sos_message_screen.dart';

class ServicesButtons extends StatelessWidget {
  const ServicesButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: RoundedImageElevatedButton(
                buttonText: 'normalRequest'.tr,
                imagePath: kAmbulanceImage,
                onPressed: () => Get.to(
                      () => const NormalRequestScreen(),
                      transition: getPageTransition(),
                    )),
          ),
          const Spacer(),
          isUserCritical()
              ? Expanded(
                  flex: 8,
                  child: RoundedImageElevatedButton(
                    buttonText: 'sosRequest'.tr,
                    imagePath: kSosImage,
                    onPressed: () {},
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
    );
  }
}
