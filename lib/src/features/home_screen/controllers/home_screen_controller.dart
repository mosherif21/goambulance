import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../constants/app_init_constants.dart';
import '../../../general/common_functions.dart';
import '../../home_dashboard/screens/home_dashboard.dart';
import '../../settings/screens/settings_screen.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get instance => Get.find();

  final controller = PersistentTabController(initialIndex: 0);
  final zoomDrawerController = ZoomDrawerController();
  final carouselController = CarouselController();

  bool isDrawerOpen(DrawerState drawerState) {
    return drawerState == DrawerState.open
        ? true
        : drawerState == DrawerState.opening
            ? true
            : drawerState == DrawerState.closing
                ? true
                : false;
  }

  Future<void> onDrawerItemSelected(int index) async {
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        await displayChangeLang();
        break;
      case 5:
        break;
    }
  }

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
  }

  List<Widget> buildScreens() {
    return [
      const HomeDashBoard(),
      const SettingsScreen(),
      const SettingsScreen(),
      const SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    final isArabic = AppInit.currentDeviceLanguage == Language.arabic;
    return [
      PersistentBottomNavBarItem(
        icon: LineIcon.home(),
        title: ('home'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: isArabic,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.search(),
        title: ('search'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: isArabic,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.history(),
        title: ('requests'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: isArabic,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle_outlined),
        title: ('account'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: isArabic,
      ),
    ];
  }
  final List<String> imgList = [
    'assets/images/accident.png',
    'assets/images/burn.png',
    'assets/images/electrocute.png',
    'assets/images/fracture.png',
    'assets/images/nose.png',
    'assets/images/wound.png'
  ];
}
