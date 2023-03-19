import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/components/home_drawer.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';

import '../../../connectivity/connectivity.dart';
import '../../../constants/app_init_constants.dart';
import '../../../general/common_functions.dart';
import '../components/navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    final homeScreenController = Get.put(HomeScreenController());
    return ZoomDrawer(
      controller: homeScreenController.zoomDrawerController,
      menuScreen: const MenuScreen(),
      mainScreen: HomeNavigationBar(homeScreenController: homeScreenController),
      borderRadius: 24.0,
      mainScreenScale: 0.2,
      isRtl: AppInit.currentDeviceLanguage == Language.english ? false : true,
      androidCloseOnBackTap: true,
      angle: 0.0,
      slideWidth: getScreenWidth(context) * 0.65,
    );
  }
}
