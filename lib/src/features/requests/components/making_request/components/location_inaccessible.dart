import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/rounded_elevated_button.dart';
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
            const SizedBox(height: 10),
            if (!makingRequestController.locationServiceEnabled.value)
              RoundedElevatedButton(
                buttonText: 'enableLocationServiceButton'.tr,
                onPressed: () async => await Location().requestService(),
                enabled: true,
                color: Colors.black,
              ),
            const SizedBox(height: 10),
            if (!makingRequestController.locationPermissionGranted.value)
              RoundedElevatedButton(
                buttonText: 'enableLocationPermissionButton'.tr,
                onPressed: () async =>
                    await makingRequestController.setupLocationPermission(),
                enabled: true,
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}
