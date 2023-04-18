import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../controllers/making_request_controller.dart';

class MakingRequestLocationInaccessible extends StatelessWidget {
  const MakingRequestLocationInaccessible({
    Key? key,
    required this.makingRequestController,
    required this.screenHeight,
  }) : super(key: key);
  final MakingRequestController makingRequestController;
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              makingRequestController.mapLoading.value
                  ? kLoadingMapAnim
                  : kNoLocation,
              height: screenHeight * 0.4,
            ),
          ],
        ),
      ),
    );
  }
}
