import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/screens/account_screen.dart';
import 'package:goambulance/src/features/notifications/screens/notifications_screen.dart';
import 'package:goambulance/src/features/payment/screens/payment_screen.dart';
import 'package:goambulance/src/features/requests/controllers/requests_history_controller.dart';
import 'package:line_icons/line_icon.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../constants/enums.dart';
import '../../../general/app_init.dart';
import '../../../general/general_functions.dart';
import '../../help_center/screens/help_screen.dart';
import '../../home_dashboard/screens/home_dashboard.dart';
import '../../information/screens/about_us_page.dart';
import '../../requests/screens/previous_requests_page.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get instance => Get.find();

  final homeBottomNavController = PersistentTabController(initialIndex: 0);
  final zoomDrawerController = ZoomDrawerController();
  final carouselController = CarouselController();

  @override
  void onReady() async {
    if (AuthenticationRepository.instance.criticalUserStatus.value ==
        CriticalUserStatus.criticalUserAccepted) {
    } else {
      handleLocation()
          .whenComplete(() => handleSmsPermission())
          .whenComplete(() => handleNotificationsPermission())
          .whenComplete(() => handleSpeechPermission())
          .whenComplete(() => listenForSos());
    }

    homeBottomNavController.addListener(() {
      if (homeBottomNavController.index == 1 &&
          Get.isRegistered<RequestsHistoryController>()) {
        RequestsHistoryController.instance.getRequestsHistory();
      }
    });
    super.onReady();
  }

  void listenForSos() async {
    if (AuthenticationRepository.instance.criticalUserStatus.value ==
        CriticalUserStatus.criticalUserAccepted) {
      final speechToText = SpeechToText();
      bool available = await speechToText.initialize(onStatus: (status) {
        if (kDebugMode) {
          AppInit.logger.i('Speech status $status');
        }
      }, onError: (error) {
        if (kDebugMode) {
          AppInit.logger.e('Speech error $error');
        }
      });
      if (available) {
        await speechToText.listen(
          listenMode: ListenMode.dictation,
          localeId: Get.locale?.languageCode,
          listenFor: const Duration(seconds: 5),
          onResult: (listenedText) async {
            if (listenedText.finalResult) {
              showSnackBar(
                  text: listenedText.recognizedWords,
                  snackBarType: SnackBarType.info);
            }
          },
        );
      }
    }
  }

  void automatedSosRequest() async {
    final locationPermissionGranted =
        await Permission.location.status.isGranted;
    final locationServiceEnabled = await Location().serviceEnabled();
    if(locationPermissionGranted&&locationServiceEnabled){

    }else{

    }
  }

  void sosRequestPress() {}


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
        displayChangeLang();
        break;
      case 3:
        Get.to(
          () => const HelpScreen(),
          transition: getPageTransition(),
        );
        break;
      case 4:
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
    homeBottomNavController.dispose();
    super.onClose();
  }
}
