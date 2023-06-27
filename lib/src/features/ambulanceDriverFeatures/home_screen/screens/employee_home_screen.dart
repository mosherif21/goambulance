// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../general/app_init.dart';
import '../../../../general/general_functions.dart';
import '../controllers/employee_home_screen_controller.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenHeight = getScreenHeight(context);
    final employeeHomeScreenController =
        Get.put(EmployeeHomeScreenController());
    return Scaffold(
      body: Stack(
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
                      bottom:
                          employeeHomeScreenController.choosingHospital.value
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
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    // CircleBackButton(
                    //   padding: 0,
                    //   onPress:( makingRequestController.onBackPressed),
                    // ),
                    SizedBox(width: 10),
                    // Obx(
                    //   () => makingRequestController.choosingHospital.value
                    //       ? const SizedBox.shrink()
                    //       : Expanded(
                    //           child: MakingRequestMapSearch(
                    //             locationController: makingRequestController,
                    //           ),
                    //         ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          // Obx(
          //       () => Positioned(
          //     bottom: makingRequestController.choosingHospital.value
          //         ? screenHeight * 0.48
          //         : 70,
          //     left: isLangEnglish() ? null : 0,
          //     right: isLangEnglish() ? 0 : null,
          //     child: MyLocationButton(
          //       controller: makingRequestController,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
