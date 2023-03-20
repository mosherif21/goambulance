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
  final RxInt currentPage = 0.obs;

  void updateCurrentPage(int index) {
    if (index == currentPage.value) return;
    currentPage.value = index;
  }

  bool isDrawerOpen(DrawerState drawerState) {
    return drawerState == DrawerState.open
        ? true
        : drawerState == DrawerState.opening
            ? true
            : drawerState == DrawerState.closing
                ? true
                : false;
  }

  Future<void> updatePage(int index) async {
    updateCurrentPage(index);
    toggleDrawer();
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
    return [
      PersistentBottomNavBarItem(
        icon: LineIcon.home(),
        title: ('home'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: AppInit.currentDeviceLanguage == Language.arabic,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.search(),
        title: ('search'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: AppInit.currentDeviceLanguage == Language.arabic,
      ),
      PersistentBottomNavBarItem(
        icon: LineIcon.history(),
        title: ('requests'.tr),
        activeColorPrimary: kDefaultColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        isArabic: AppInit.currentDeviceLanguage == Language.arabic,
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
        isArabic: AppInit.currentDeviceLanguage == Language.arabic,
      ),
    ];
  }

  static final List<String> imgList = [
    'assets/images/accident.png',
    'assets/images/burn.png',
    'assets/images/electrocute.png',
    'assets/images/fracture.png',
    'assets/images/nose.png',
    'assets/images/wound.png'
  ];
  static final List<String> txtList= [
    'firstAidTips1',
    'firstAidTips2',
    'firstAidTips3',
    'firstAidTips4',
    'firstAidTips5',
    'firstAidTips6'
  ];
  final List<Widget> imageSliders = imgList
      .map(
        (item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.asset(item, fit: BoxFit.contain, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        '${txtList.elementAt(imgList.indexOf(item)).tr} ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      )
      .toList();
}
