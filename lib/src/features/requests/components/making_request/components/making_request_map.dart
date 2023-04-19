import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_controller.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/general_functions.dart';

class MakingRequestMap extends StatelessWidget {
  const MakingRequestMap({
    Key? key,
    required this.makingRequestController,
  }) : super(key: key);
  final MakingRequestController makingRequestController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: const EdgeInsets.only(bottom: 70, left: 5),
          compassEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          mapToolbarEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: makingRequestController.locationAvailable.value
                ? makingRequestController.currentLocationGetter()
                : makingRequestController.searchedLocation,
            zoom: 14.5,
          ),
          polylines: makingRequestController.mapPolyLines,
          markers: makingRequestController.mapMarkers,
          onMapCreated: (GoogleMapController controller) =>
              makingRequestController.mapControllerCompleter
                  .complete(controller),
        ),
        Positioned(
          top: 0,
          left: isLangEnglish() ? 0 : null,
          right: isLangEnglish() ? null : 0,
          child: SafeArea(
            child: Row(
              children: const [
                CircleBackButton(padding: 15),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                RegularElevatedButton(
                  buttonText: 'requestHere'.tr,
                  onPressed: () {},
                  enabled: true,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
