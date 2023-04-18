import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_controller.dart';

import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/general_functions.dart';
import 'components/location_inaccessible.dart';
import 'components/making_request_map.dart';

class MakingNormalRequestPage extends StatelessWidget {
  const MakingNormalRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final makingRequestController = Get.put(MakingRequestController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(
            () => makingRequestController.locationAvailable.value
                ? MakingRequestMap(
                    makingRequestController: makingRequestController,
                  )
                : MakingRequestLocationInaccessible(
                    makingRequestController: makingRequestController,
                    screenHeight: screenHeight,
                  ),
          ),
          Obx(
            () => Positioned(
              top: 0,
              left: isLangEnglish() ? 0 : null,
              right: isLangEnglish() ? null : 0,
              child: SafeArea(
                child: makingRequestController.locationAvailable.value
                    ? const CircleBackButton(padding: 15)
                    : const RegularBackButton(padding: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
