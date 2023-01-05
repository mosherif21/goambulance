import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../general/common_functions.dart';
import '../../controllers/maps_controller.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = getScreenHeight(context);
    final mapsController = Get.put(MapsController());
    return Obx(
      () => mapsController.servicePermissionEnabled.value
          ? SizedBox(
              height: screenHeight * 0.8,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: mapsController.currentLocationGetter(), zoom: 14.5),
                polylines: {
                  Polyline(
                      polylineId: const PolylineId("route test"),
                      points:
                          // ignore: invalid_use_of_protected_member
                          mapsController.polylineCoordinates.value,
                      width: 3),
                },
                markers: {mapsController.driverMarker},
              ),
            )
          : SizedBox(
              height: screenHeight * 0.8,
            ),
    );
  }
}
