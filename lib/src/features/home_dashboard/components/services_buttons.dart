import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../constants/assets_strings.dart';
import '../../../constants/enums.dart';
import '../../../general/common_widgets/rounded_image_button.dart';
import '../../../general/general_functions.dart';
import '../../requests/components/making_request/components/normal_request_screen.dart';
import '../../sos_message/screens/sos_message_screen.dart';

class ServicesButtons extends StatelessWidget {
  const ServicesButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Obx(
        () => Row(
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
            AuthenticationRepository.instance.criticalUserStatus.value ==
                    CriticalUserStatus.criticalUserAccepted
                ? Expanded(
                    flex: 8,
                    child: RoundedImageElevatedButton(
                      buttonText: 'sosRequest'.tr,
                      imagePath: kSosImage,
                      onPressed: () =>
                          HomeScreenController.instance.sosRequestPress(),
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
      ),
    );
  }
}
