import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_controller.dart';

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
      body: Obx(
        () => makingRequestController.mapEnabled.value
            ? MakingRequestMap(
                makingRequestController: makingRequestController,
              )
            : MakingRequestLocationInaccessible(
                makingRequestController: makingRequestController,
                screenHeight: screenHeight,
              ),
      ),
    );
  }
}
