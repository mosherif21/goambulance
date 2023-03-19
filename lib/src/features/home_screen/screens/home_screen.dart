import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../connectivity/connectivity.dart';
import '../components/home_page.dart';
import '../controllers/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    Get.put(HomeScreenController());
    return const HomeNavigationDrawer();
  }
}
