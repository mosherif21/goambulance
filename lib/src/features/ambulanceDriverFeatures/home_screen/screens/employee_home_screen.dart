import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/employee_map/employee_notifications_button.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/main_screen/controllers/employee_main_screen_controller.dart';

import '../components/employee_map/employee_loading_hospital.dart';
import '../components/employee_map/employee_map_screen.dart';
import '../components/employee_map/hospital_get_failed.dart';
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
    final employeeHomeScreenController =
        Get.put(EmployeeHomeScreenController());
    final mainScreenController = EmployeeMainScreenController.instance;
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => employeeHomeScreenController.hospitalLoaded.value
                ? employeeHomeScreenController.hospitalDataAvailable.value
                    ? const EmployeeMapScreen()
                    : Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 50,
                        child: EmployeeHospitalGetFailed(
                          onTryAgainPressed: () =>
                              employeeHomeScreenController.loadHospitalInfo(),
                        ),
                      )
                : const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 50,
                    child: EmployeeLoadingHospital(),
                  ),
          ),
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
        ],
      ),
    );
  }
}
