import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'connectivity_controller.dart';

class ConnectivityChecker {
  static ConnectivityController checkConnection(
      BuildContext context, double screenHeight, bool displayAlert) {
    final ConnectivityController connectivityController =
        Get.find<ConnectivityController>();
    connectivityController.updateContext(context, screenHeight, displayAlert);
    return connectivityController;
  }
}
