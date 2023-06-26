import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';

import '../../../../../authentication/authentication_repository.dart';
import '../../../../general/general_functions.dart';
import '../../../help_center/screens/help_screen.dart';
import '../../../information/screens/about_us_page.dart';
import '../../../notifications/screens/notifications_screen.dart';

class EmployeeHomeScreenController extends GetxController {
  static EmployeeHomeScreenController get instance => Get.find();

  final zoomDrawerController = ZoomDrawerController();
  final navBarIndex = 0.obs;
  late final FirebaseAmbulanceEmployeeDataAccess firebaseEmployeeDataAccess;
  late final AuthenticationRepository authenticationRepository;

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
          // () => const TestNav1(),
          () => const NotificationsScreen(),
          transition: getPageTransition(),
        );
        break;
      case 1:
        displayChangeLang();
        break;
      case 2:
        Get.to(
          () => const HelpScreen(),
          transition: getPageTransition(),
        );
        break;
      case 3:
        Get.to(
          () => const AboutUsScreen(),
          transition: getPageTransition(),
        );
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
    super.onClose();
  }
}
