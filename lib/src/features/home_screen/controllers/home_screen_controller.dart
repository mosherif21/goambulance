import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/colors.dart';
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
    handleLocation(showSnackBar: false);
    super.onReady();
  }

  bool isDrawerOpen(DrawerState drawerState) =>
      drawerState == DrawerState.open ||
              drawerState == DrawerState.opening ||
              drawerState == DrawerState.closing
          ? true
          : false;

  Future<void> onDrawerItemSelected(int index) async {
    switch (index) {
      case 0:
        await Get.to(() => const PaymentScreen());
        break;
      case 1:
        await Get.to(() => const NotificationsScreen());
        break;
      case 2:
        await Get.to(() => const SettingsScreen());
        break;
      case 3:
        await displayChangeLang();
        break;
      case 4:
        await Get.to(() => const HelpScreen());
        break;
      case 5:
        await Get.to(() => const AboutUsScreen());
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
    final isArabic = !isLangEnglish();
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
        icon: const Icon(Icons.account_circle_outlined),
        title: ('account'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: isArabic,
      ),
    ];
  }

  @override
  void onClose() {
    homeBottomTabController.dispose();
    super.onClose();
  }
}
