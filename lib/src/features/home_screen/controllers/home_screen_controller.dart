import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/screens/account_screen.dart';
import 'package:goambulance/src/features/notifications/screens/notifications_screen.dart';
import 'package:goambulance/src/features/payment/screens/payment_screen.dart';
import 'package:goambulance/src/features/search/screens/search_page.dart';
import 'package:goambulance/src/features/settings/components/about_us_page.dart';
import 'package:goambulance/src/features/settings/screens/settings_screen.dart';
import 'package:line_icons/line_icon.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../general/general_functions.dart';
import '../../help_center/screens/help_screen.dart';
import '../../home_dashboard/screens/home_dashboard.dart';
import '../../requests/screens/previous_requests_page.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get instance => Get.find();

  final homeBottomTabController = PersistentTabController(initialIndex: 0);
  final zoomDrawerController = ZoomDrawerController();
  final carouselController = CarouselController();
  RxBool hideNavBar = false.obs;

  @override
  void onReady() {
    handleLocation();
    handleSmsPermission();
    super.onReady();
  }

  bool isDrawerOpen(DrawerState drawerState) =>
      drawerState == DrawerState.open ||
              drawerState == DrawerState.opening ||
              drawerState == DrawerState.closing
          ? true
          : false;

  void onDrawerItemSelected(int index) {
    switch (index) {
      case 0:
        Get.to(
          () => const PaymentScreen(),
          transition: getPageTransition(),
        );
        break;
      case 1:
        Get.to(
          () => const NotificationsScreen(),
          transition: getPageTransition(),
        );
        break;
      case 2:
        Get.to(
          () => const SettingsScreen(),
          transition: getPageTransition(),
        );
        break;
      case 3:
        displayChangeLang();
        break;
      case 4:
        Get.to(
          () => const HelpScreen(),
          transition: getPageTransition(),
        );
        break;
      case 5:
        Get.to(
          () => const AboutUsScreen(),
          transition: getPageTransition(),
        );
        break;
    }
  }

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
  }

  List<Widget> buildScreens() {
    return [
      const HomeDashBoard(),
      const SearchScreen(),
      const PreviousRequestsPage(),
      const AccountScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: LineIcon.home(),
        title: ('home'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.search(),
        title: ('search'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.history(),
        title: ('requests'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle_outlined),
        title: ('account'.tr),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  void onClose() {
    homeBottomTabController.dispose();
    super.onClose();
  }
}
