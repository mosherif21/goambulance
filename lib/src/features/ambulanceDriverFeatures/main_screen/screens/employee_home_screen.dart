import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';

import '../../../../connectivity/connectivity.dart';
import '../../../../general/general_functions.dart';
import '../components/employee_drawer_page.dart';
import '../components/employee_home_navigation_bar.dart';
import '../controllers/employee_home_screen_controller.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final homeScreenController = Get.put(EmployeeHomeScreenController());
    ConnectivityChecker.checkConnection(displayAlert: true);
    Get.put(FirebaseAmbulanceEmployeeDataAccess());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            final drawerState =
                homeScreenController.zoomDrawerController.stateNotifier?.value;
            if (drawerState == DrawerState.open ||
                drawerState == DrawerState.opening) {
              homeScreenController.toggleDrawer();
              return false;
            } else if (homeScreenController.navBarIndex.value != 0) {
              homeScreenController.navBarIndex.value = 0;
              return false;
            } else {
              return true;
            }
          },
          child: ZoomDrawer(
            controller: homeScreenController.zoomDrawerController,
            menuScreen: EmployeeDrawerPage(
              [
                MenuClass('notifications'.tr, Icons.notifications, 0),
                MenuClass('lang'.tr, Icons.language, 1),
                MenuClass('help'.tr, Icons.help, 2),
                MenuClass('aboutUs'.tr, Icons.info_outline, 3),
              ],
              callback: (index) =>
                  homeScreenController.onDrawerItemSelected(index),
              current: 0,
            ),
            mainScreen: const EmployeeHomeNavigationBar(),
            openCurve: Curves.fastOutSlowIn,
            showShadow: false,
            slideWidth: MediaQuery.of(context).size.width * (0.6),
            isRtl: isLangEnglish() ? false : true,
            mainScreenTapClose: true,
            borderRadius: 15,
            angle: 0.0,
            menuScreenWidth: double.infinity,
            mainScreenScale: 0.15,
            moveMenuScreen: true,
            style: DrawerStyle.defaultStyle,
            mainScreenAbsorbPointer: true,
            disableDragGesture: true,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300, //New
                blurRadius: 15,
                offset: const Offset(0, 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
