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
        homeScreenController.mainMenu,
        callback: homeScreenController.updatePage,
        current: 0,
      ),
      mainScreen:   const HomeNavigationBar(),
      openCurve: Curves.fastOutSlowIn,
      showShadow: false,
      slideWidth: MediaQuery.of(context).size.width * (0.5),
      isRtl: isRtl,
      mainScreenTapClose: true,
      borderRadius: 10,
      angle: 0.0,
      menuScreenWidth: double.infinity,
      mainScreenScale: 0.2,
      moveMenuScreen: false,
      style: DrawerStyle.defaultStyle,
      drawerShadowsBackgroundColor: Colors.yellow,
      mainScreenAbsorbPointer: false,
      disableDragGesture: false,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 20.0,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final rtl =
//         AppInit.currentDeviceLanguage == Language.english ? false : true;
//     return ValueListenableBuilder<DrawerState>(
//       valueListenable: ZoomDrawer.of(context)!.stateNotifier,
//       builder: (context, state, child) {
//         return AbsorbPointer(
//           absorbing: state != DrawerState.closed,
//           child: child,
//         );
//       },
//       child: GestureDetector(
//         child: const HomeNavigationBar();
//         onPanUpdate: (details) {
//           if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
//             ZoomDrawer.of(context)?.toggle.call();
//           }
//         },
//       ),
//     );
//   }
// }
