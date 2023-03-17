import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../connectivity/connectivity.dart';
import '../components/navigation_bar.dart';
import '../controllers/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    final homeScreenController = Get.put(HomeScreenController());
    return HomeNavigationBar(homeScreenController: homeScreenController);
  }
}
