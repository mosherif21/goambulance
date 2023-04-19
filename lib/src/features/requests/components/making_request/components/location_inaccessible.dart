import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../../../general/general_functions.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RegularBackButton(padding: 0),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Obx(
                      () => Lottie.asset(
                        makingRequestController.mapLoading.value
                            ? kLoadingMapAnim
                            : kNoLocation,
                        //: kNoLocation,
                        height: makingRequestController.mapLoading.value
                            ? screenHeight * 0.7
                            : screenHeight * 0.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => !makingRequestController.mapLoading.value
                      ? Column(
                          children: [
                            AutoSizeText(
                              'locationNotAccessed'.tr,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => !makingRequestController
                                      .locationServiceEnabled.value
                                  ? RoundedElevatedButton(
                                      buttonText:
                                          'enableLocationServiceButton'.tr,
                                      onPressed: () async =>
                                          await handleLocationService(),
                                      enabled: true,
                                      color: Colors.black,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => !makingRequestController
                                      .locationPermissionGranted.value
                                  ? RoundedElevatedButton(
                                      buttonText:
                                          'enableLocationPermissionButton'.tr,
                                      onPressed: () async =>
                                          await makingRequestController
                                              .setupLocationPermission(),
                                      enabled: true,
                                      color: Colors.black,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 10),
                            RoundedElevatedButton(
                              buttonText: 'searchPlace'.tr,
                              onPressed: () async =>
                                  await makingRequestController
                                      .googlePlacesSearch(context: context),
                              enabled: true,
                              color: Colors.black,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
