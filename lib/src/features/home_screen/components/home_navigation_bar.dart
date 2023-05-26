import 'package:flutter/material.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return PersistentTabView(
      context,
      margin: const EdgeInsets.all(15),
      bottomScreenMargin: 0,
      controller: homeScreenController.homeBottomTabController,
      screens: homeScreenController.buildScreens(),
      items: homeScreenController.navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(20.0),
        colorBehindNavBar: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300, //New
            blurRadius: 7,
          )
        ],
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 100),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: false,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 100),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}
