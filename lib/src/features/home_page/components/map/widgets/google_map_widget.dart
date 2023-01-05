import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lot;

import '../../../../../general/common_functions.dart';
import '../map_controllers/maps_controller.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
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
                mapsController.routPolyLine.value,
              },
              markers: {
                mapsController.driverMarker.value,
                if (AppInit.isWeb)
                  Marker(
                      markerId: const MarkerId('current_location'),
                      position: mapsController.currentLocationGetter()),
              },
              onMapCreated: (GoogleMapController controller) =>
                  mapsController.googleMapController = controller,
            )
          : SizedBox(
              child: Center(
                child: lot.Lottie.asset(
                  mapsController.mapStatus == MapStatus.loadingMapData
                      ? kLoadingMapAnim
                      : kNoLocation,
                  height: mapsController.mapStatus == MapStatus.loadingMapData
                      ? screenHeight * 0.3
                      : screenHeight * 0.4,
                ),
              ),
            ),
    );
  }
}
