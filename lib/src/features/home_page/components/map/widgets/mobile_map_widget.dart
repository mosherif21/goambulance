import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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
    return Obx(
      () => mapsController.servicePermissionEnabled.value
          ? SizedBox(
              height: screenHeight * 0.8,
              child: SizedBox(
                height: screenHeight * 0.8,
                child: GoogleMap(
                  mapToolbarEnabled: false,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: mapsController.currentLocationGetter(),
                      zoom: 14.5),
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
              ),
            )
          : SizedBox(
              height: screenHeight * 0.8,
              child: const Center(child: Text('location disabled'))),
    );
  }
}

MapWidget getMapWidget() {
  if (kDebugMode) {
    print("get map mobile ");
  }
  return const MobileMapWidget();
}
