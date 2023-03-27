import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

import '../controllers/home_screen_controller.dart';
import 'drawer_page.dart';
import 'home_navigation_bar.dart';

class HomeNavigationDrawer extends StatelessWidget {
  const HomeNavigationDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return ZoomDrawer(
      controller: homeScreenController.zoomDrawerController,
      menuScreen: DrawerPage(
        [
          MenuClass('payment'.tr, Icons.payment, 0),
          MenuClass('notifications'.tr, Icons.notifications, 1),
          MenuClass('settings'.tr, Icons.settings, 2),
          MenuClass('langLong'.tr, Icons.language, 3),
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
      isRtl: AppInit.currentDeviceLanguage == Language.english ? false : true,
      mainScreenTapClose: true,
      borderRadius: 10,
      angle: 0.0,
      menuScreenWidth: double.infinity,
      mainScreenScale: 0.15,
      moveMenuScreen: false,
      style: DrawerStyle.defaultStyle,
      drawerShadowsBackgroundColor: Colors.yellow,
      mainScreenAbsorbPointer: false,
      disableDragGesture: false,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20.0,
          offset: const Offset(0, 40),
        ),
      ],
    );
  }
}
