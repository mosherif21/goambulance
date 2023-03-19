import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

import '../controllers/home_screen_controller.dart';
import 'home_navigation_bar.dart';
import 'menu_page.dart';

class HomeScreenTest extends StatelessWidget {
  const HomeScreenTest({super.key});
  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    final isRtl =
        AppInit.currentDeviceLanguage == Language.english ? false : true;
    return ZoomDrawer(
      controller: homeScreenController.zoomDrawerController,
      menuScreen: MenuScreen(
        homeScreenController.mainMenu,
        callback: homeScreenController.updatePage,
        current: 0,
      ),
      mainScreen: const MainScreen(),
      openCurve: Curves.fastOutSlowIn,
      showShadow: false,
      slideWidth: MediaQuery.of(context).size.width * (0.6),
      isRtl: isRtl,
      mainScreenTapClose: true,
      mainScreenOverlayColor: Colors.brown.withOpacity(0.5),
      borderRadius: 10,
      angle: 0.0,
      menuScreenWidth: double.infinity,
      moveMenuScreen: false,
      style: DrawerStyle.defaultStyle,
      drawerShadowsBackgroundColor: Colors.yellow,
      mainScreenAbsorbPointer: false,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rtl = false;
    return ValueListenableBuilder<DrawerState>(
      valueListenable: ZoomDrawer.of(context)!.stateNotifier,
      builder: (context, state, child) {
        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        child: const HomeNavigationBar(),
        onPanUpdate: (details) {
          if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
            ZoomDrawer.of(context)?.toggle.call();
          }
        },
      ),
    );
  }
}
