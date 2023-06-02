import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/or_divider.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../../../general/general_functions.dart';

class LocationInaccessible extends StatelessWidget {
  const LocationInaccessible({
    Key? key,
    required this.locationController,
    required this.screenHeight,
  }) : super(key: key);
  final dynamic locationController;
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'requestLocation'.tr,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => Lottie.asset(
                      locationController.mapLoading.value
                          ? kLoadingMapAnim
                          : kNoLocation,
                      height: locationController.mapLoading.value
                          ? screenHeight * 0.8
                          : screenHeight * 0.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => !locationController.mapLoading.value
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
                                () => !locationController
                                        .locationServiceEnabled.value
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: RoundedElevatedButton(
                                          buttonText:
                                              'enableLocationServiceButton'.tr,
                                          onPressed: () =>
                                              handleLocationService(),
                                          enabled: true,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              Obx(
                                () => !locationController
                                        .locationPermissionGranted.value
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: RoundedElevatedButton(
                                          buttonText:
                                              'enableLocationPermissionButton'
                                                  .tr,
                                          onPressed: () => locationController
                                              .setupLocationPermission(),
                                          enabled: true,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              const OrDivider(),
                              RoundedElevatedButton(
                                buttonText: 'searchPlace'.tr,
                                onPressed: () => locationController
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
      ),
    );
  }
}
