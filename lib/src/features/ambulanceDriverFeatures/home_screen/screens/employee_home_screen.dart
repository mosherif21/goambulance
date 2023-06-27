// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/employee_notifications_button.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/main_screen/controllers/employee_main_screen_controller.dart';
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
    final mainScreenController = EmployeeMainScreenController.instance;
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Material(
                      elevation: 5,
                      shape: const CircleBorder(),
                      color: Colors.white,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashFactory: InkSparkle.splashFactory,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: ValueListenableBuilder(
                            valueListenable: mainScreenController
                                .zoomDrawerController.stateNotifier!,
                            builder: (BuildContext context,
                                DrawerState drawerState, Widget? child) {
                              return Icon(
                                mainScreenController.isDrawerOpen(drawerState)
                                    ? Icons.close
                                    : Icons.menu_outlined,
                                size: 30,
                              );
                            },
                          ),
                        ),
                        onTap: () => mainScreenController.toggleDrawer(),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => EmployeeNotificationsButton(
                        notificationsCount: employeeHomeScreenController
                            .notificationsCount.value,
                      ),
                    ),
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
