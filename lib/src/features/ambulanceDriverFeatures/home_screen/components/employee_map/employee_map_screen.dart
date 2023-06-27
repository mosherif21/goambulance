// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../general/app_init.dart';
import '../../../../../general/general_functions.dart';
import '../../../../requests/components/making_request/components/my_location_button.dart';
import '../../controllers/employee_home_screen_controller.dart';

class EmployeeMapScreen extends StatelessWidget {
  const EmployeeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final employeeHomeScreenController = EmployeeHomeScreenController.instance;
    return Stack(
      children: [
        Obx(
          () => GoogleMap(
            compassEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            padding: AppInit.isWeb
                ? EdgeInsets.zero
                : EdgeInsets.only(
                    bottom: employeeHomeScreenController.choosingHospital.value
                        ? screenHeight * 0.48
                        : 80,
                    left: 10,
                    right: 10,
                    top: screenHeight * 0.16,
                  ),
            initialCameraPosition:
                employeeHomeScreenController.getInitialCameraPosition(),
            polylines: employeeHomeScreenController.mapPolyLines.value,
            markers: employeeHomeScreenController.mapMarkers.value,
            onMapCreated: (GoogleMapController controller) =>
                employeeHomeScreenController.mapControllerCompleter
                    .complete(controller),
            onCameraMove: employeeHomeScreenController.onCameraMove,
            onCameraIdle: employeeHomeScreenController.onCameraIdle,
            onTap: employeeHomeScreenController.onMapTap,
          ),
        ),
        // CustomInfoWindow(
        //   controller: makingRequestController.requestLocationWindowController,
        //   height: isLangEnglish() ? 50 : 56,
        //   width: 150,
        //   offset: 50,
        // ),
        // CustomInfoWindow(
        //   controller: makingRequestController.hospitalWindowController,
        //   height: isLangEnglish() ? 50 : 56,
        //   width: 150,
        //   offset: 50,
        // ),
        // CustomInfoWindow(
        //   controller: makingRequestController.ambulanceWindowController,
        //   height: isLangEnglish() ? 50 : 56,
        //   width: 150,
        //   offset: 50,
        // ),
        Obx(
          () => Positioned(
            bottom:
                // makingRequestController.choosingHospital.value
                //     ? screenHeight * 0.48
                //     :
                70,
            left: isLangEnglish() ? null : 0,
            right: isLangEnglish() ? 0 : null,
            child: MyLocationButton(
              onLocationButtonPress: () {},
            ),
          ),
        ),
      ],
    );
  }
}
