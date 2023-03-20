import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

import '../controllers/home_screen_controller.dart';
import 'drawer_page.dart';
import 'home_navigation_bar.dart';

class HomeNavigationDrawer extends StatelessWidget {
  const HomeNavigationDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    final isRtl =
        AppInit.currentDeviceLanguage == Language.english ? false : true;
    return ZoomDrawer(
      controller: homeScreenController.zoomDrawerController,
      menuScreen: DrawerPage(
        const [
          MenuClass("payment", Icons.payment, 0),
          MenuClass("promos", Icons.card_giftcard, 1),
          MenuClass("notifications", Icons.notifications, 2),
          MenuClass("help", Icons.help, 3),
          MenuClass("about_us", Icons.info_outline, 4),
        ],
        callback: (index) async => await homeScreenController.updatePage(index),
        current: 0,
      ),
      mainScreen: const HomeNavigationBar(),
      openCurve: Curves.fastOutSlowIn,
      showShadow: false,
      slideWidth: MediaQuery.of(context).size.width * (0.55),
      isRtl: isRtl,
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
          color: Colors.black.withOpacity(0.5),
          blurRadius: 20.0,
        ),
      ],
    );
  }
}
