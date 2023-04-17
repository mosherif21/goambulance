import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lot;

import '../../../../constants/enums.dart';
import '../../../../general/general_functions.dart';
import '../../controllers/making_request_controller.dart';

class MakingRequestMapWidget extends StatelessWidget {
  const MakingRequestMapWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final makingRequestController = MakingRequestController.instance;
    return Obx(
      () => makingRequestController.locationAvailable.value
          ? GoogleMap(
              compassEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: initialCameraPosition, zoom: 14.5),
              polylines: polyLines,
              markers: markers,
              onMapCreated: (GoogleMapController controller) =>
                  mapController = controller,
            )
          : SizedBox(
              child: Center(
                child: lot.Lottie.asset(
                  makingRequestController.mapLoading.value
                      ? kLoadingMapAnim
                      : kNoLocation,
                  height: makingRequestController.mapLoading.value
                      ? screenHeight * 0.3
                      : screenHeight * 0.4,
                ),
              ),
            ),
    );
  }
}
