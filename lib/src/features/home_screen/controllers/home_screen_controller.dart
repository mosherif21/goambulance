import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../constants/colors.dart';
import '../../home_dashboard/screens/home_dashboard.dart';
import '../../settings/screens/settings_screen.dart';
import '../components/menu_page.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get instance => Get.find();

  final controller = PersistentTabController(initialIndex: 0);
  final zoomDrawerController = ZoomDrawerController();

  final RxInt currentPage = 0.obs;

  void updateCurrentPage(int index) {
    if (index == currentPage.value) return;
    currentPage.value = index;
  }

  void updatePage(int index) {
    updateCurrentPage(index);
    toggleDrawer();
  }

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
  }

  List<MenuClass> mainMenu = const [
    MenuClass("payment", Icons.payment, 0),
    MenuClass("promos", Icons.card_giftcard, 1),
    MenuClass("notifications", Icons.notifications, 2),
    MenuClass("help", Icons.help, 3),
    MenuClass("about_us", Icons.info_outline, 4),
  ];

  List<Widget> buildScreens() {
    return [
      const HomeDashBoard(),
      const SettingsScreen(),
      const SettingsScreen(),
      const SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: LineIcon.home(),
        title: ('home'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.search(),
        title: ('Search'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.history(),
        title: ('Requests'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const CircleAvatar(
          radius: 12,
          backgroundImage: NetworkImage(
            'https://sooxt98.space/content/images/size/w100/2019/01/profile.png',
          ),
        ),
        title: ('Account'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
