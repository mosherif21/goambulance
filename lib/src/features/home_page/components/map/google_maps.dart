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
          ? Container(
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
            )
          : SizedBox(
              height: screenHeight * 0.8,
              child: const Center(child: Text('location disabled')),
            ),
    );
  }
}
