import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../../general/general_functions.dart';
import '../controllers/home_screen_controller.dart';
import 'drawer_page.dart';
import 'home_navigation_bar.dart';

class HomeNavigationDrawer extends StatelessWidget {
  const HomeNavigationDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final homeScreenController = Get.put(HomeScreenController());
    return WillPopScope(
      onWillPop: () async {
        final drawerState =
            homeScreenController.zoomDrawerController.stateNotifier?.value;
        if (drawerState == DrawerState.open ||
            drawerState == DrawerState.opening) {
          homeScreenController.toggleDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: ZoomDrawer(
        controller: homeScreenController.zoomDrawerController,
        menuScreen: DrawerPage(
          [
            MenuClass('payment'.tr, Icons.payment, 0),
            MenuClass('notifications'.tr, Icons.notifications, 1),
            MenuClass('settings'.tr, Icons.settings, 2),
            MenuClass('lang'.tr, Icons.language, 3),
            MenuClass('help'.tr, Icons.help, 4),
            MenuClass('aboutUs'.tr, Icons.info_outline, 5),
          ],
          callback: (index) async =>
              await homeScreenController.onDrawerItemSelected(index),
          current: 0,
        ),
        mainScreen: const HomeNavigationBar(),
        openCurve: Curves.fastOutSlowIn,
        showShadow: false,
        slideWidth: MediaQuery.of(context).size.width * (0.6),
        isRtl: isLangEnglish() ? false : true,
        mainScreenTapClose: true,
        borderRadius: 10,
        angle: 0.0,
        menuScreenWidth: double.infinity,
        mainScreenScale: 0.15,
        moveMenuScreen: false,
        style: DrawerStyle.defaultStyle,
        mainScreenAbsorbPointer: true,
        disableDragGesture: false,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300, //New
            blurRadius: 10.0,
            offset: const Offset(0, 15),
          ),
        ],
      ),
    );
  }
}
