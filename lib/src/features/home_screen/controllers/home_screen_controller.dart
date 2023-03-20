import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../constants/app_init_constants.dart';
import '../../../constants/colors.dart';
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

  Future<void> onDrawerItemSelected(int index) async {}

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
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: isArabic,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.search(),
        title: ('search'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: isArabic,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.history(),
        title: ('requests'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: isArabic,
      ),
      PersistentBottomNavBarItem(
        icon: const CircleAvatar(
          radius: 12,
          backgroundImage: NetworkImage(
            'https://sooxt98.space/content/images/size/w100/2019/01/profile.png',
          ),
        ),
        title: ('account'.tr),
        activeColorPrimary: kDefaultColor,
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
