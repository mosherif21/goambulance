import 'package:flutter/cupertino.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';

import '../../../../../authentication/authentication_repository.dart';
import '../../../../general/general_functions.dart';
import '../../../information/screens/about_us_page.dart';
import '../../account/notifications/screens/employee_notifcations_screen.dart';

class EmployeeMainScreenController extends GetxController {
  static EmployeeMainScreenController get instance => Get.find();

  final zoomDrawerController = ZoomDrawerController();
  final navBarIndex = 0.obs;
  late final FirebaseAmbulanceEmployeeDataAccess firebaseEmployeeDataAccess;
  late final AuthenticationRepository authenticationRepository;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void onReady() async {
    firebaseEmployeeDataAccess = FirebaseAmbulanceEmployeeDataAccess.instance;
    authenticationRepository = AuthenticationRepository.instance;
    authenticationRepository.loadProfilePicUrl();
    handleLocation()
        .whenComplete(() => handleNotificationsPermission())
        .whenComplete(() => handleSpeechPermission());
    super.onReady();
  }

  void navigationBarOnTap(int navIndex) async {
    navBarIndex.value = navIndex;
    pageController.animateToPage(
      navIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> onWillPopScope() {
    final drawerState = zoomDrawerController.stateNotifier?.value;
    if (drawerState == DrawerState.open || drawerState == DrawerState.opening) {
      toggleDrawer();
      return Future.value(false);
    } else if (navBarIndex.value != 0) {
      navBarIndex.value = 0;
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
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
          () => const EmployeeNotificationsScreen(),
          transition: getPageTransition(),
        );
        break;
      case 1:
        Get.to(
          () => const AboutUsScreen(),
          transition: getPageTransition(),
        );
        break;
      case 2:
        displayChangeLang();
        break;
      default:
        break;
    }
  }

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
  }

  @override
  void onClose() async {
    pageController.dispose();
    super.onClose();
  }
}
