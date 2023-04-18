import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../../general/general_functions.dart';

class MakingNormalRequestPage extends StatelessWidget {
  const MakingNormalRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final makingRequestController = Get.put(MakingRequestController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'normalRequest'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        scrolledUnderElevation: 5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => makingRequestController.locationAvailable.value
                  ? GoogleMap(
                      compassEnabled: false,
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      mapToolbarEnabled: false,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: makingRequestController.currentLocationGetter(),
                        zoom: 14.5,
                      ),
                      polylines: makingRequestController.mapPolyLines,
                      markers: makingRequestController.mapMarkers,
                      onMapCreated: (GoogleMapController controller) =>
                          makingRequestController.mapController = controller,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
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
                          if (!makingRequestController.mapLoading.value)
                            RoundedElevatedButton(
                              buttonText: 'enableLocationServiceButton'.tr,
                              onPressed: () async =>
                                  await Location().requestService(),
                              enabled: true,
                              color: Colors.black,
                            ),
                          const SizedBox(height: 10),
                          if (!makingRequestController
                              .locationPermissionGranted.value)
                            RoundedElevatedButton(
                              buttonText: 'enableLocationPermissionButton'.tr,
                              onPressed: () async => makingRequestController
                                      .locationPermissionGranted.value =
                                  await handleLocationPermission(
                                      showSnackBar: true),
                              enabled: true,
                              color: Colors.black,
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
