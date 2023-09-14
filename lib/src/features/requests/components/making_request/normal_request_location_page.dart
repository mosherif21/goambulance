import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_location_controller.dart';

import '../../../../general/general_functions.dart';
import '../general/location_inaccessible.dart';
import 'making_request_map.dart';

class NormalRequestLocationPage extends StatelessWidget {
  const NormalRequestLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final makingRequestController = Get.put(MakingRequestLocationController());
    return Obx(
      () => makingRequestController.mapEnabled.value
          ? MakingRequestMap(
              makingRequestController: makingRequestController,
            )
          : LocationInaccessible(
              locationController: makingRequestController,
              screenHeight: screenHeight,
            ),
    );
  }
}
