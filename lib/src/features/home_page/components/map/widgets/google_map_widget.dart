import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../map_controllers/maps_controller.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapsController = MapsController.instance;
    return Obx(
      () => mapsController.servicePermissionEnabled.value
          ? GoogleMap(
              compassEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
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
              markers: {
                mapsController.driverMarker,
                if (AppInit.isWeb)
                  Marker(
                      markerId: const MarkerId('current_location'),
                      position: mapsController.currentLocationGetter()),
              },
            )
          : const SizedBox(child: Center(child: Text('location disabled'))),
    );
  }
}
