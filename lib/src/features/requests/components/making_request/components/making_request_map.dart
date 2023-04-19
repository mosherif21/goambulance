import 'package:flutter/material.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_controller.dart';
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
          child: const SafeArea(
            child: CircleBackButton(padding: 15),
          ),
        ),
      ],
    );
  }
}
