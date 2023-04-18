import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:goambulance/src/features/requests/controllers/making_request_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MakingRequestMap extends StatelessWidget {
  const MakingRequestMap({
    Key? key,
    required this.makingRequestController,
  }) : super(key: key);
  final MakingRequestController makingRequestController;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GoogleMap(
        compassEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        mapToolbarEnabled: false,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: makingRequestController.currentLocationGetter(),
          zoom: 15.5,
        ),
        polylines: makingRequestController.mapPolyLines,
        markers: makingRequestController.mapMarkers,
        onMapCreated: (GoogleMapController controller) =>
            makingRequestController.mapController = controller,
      ),
    );
  }
}
