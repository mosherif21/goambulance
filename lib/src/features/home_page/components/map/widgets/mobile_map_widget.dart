import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../general/common_functions.dart';
import '../map_controllers/maps_controller.dart';
import 'abstract_map_widget.dart';

class MobileMapWidget extends StatelessWidget implements MapWidget {
  const MobileMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = getScreenHeight(context);
    final mapsController = MapsController.instance;
    return Container(
      height: screenHeight * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: GoogleMap(
        mapToolbarEnabled: false,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: mapsController.currentLocationGetter(), zoom: 14.5),
        polylines: {
          Polyline(
              polylineId: const PolylineId("route test"),
              points:
                  // ignore: invalid_use_of_protected_member
                  mapsController.polylineCoordinates.value,
              color: const Color(0xFF28AADC),
              width: 3),
        },
        markers: {mapsController.driverMarker},
      ),
    );
  }
}

MapWidget getMapWidget() {
  return const MobileMapWidget();
}
