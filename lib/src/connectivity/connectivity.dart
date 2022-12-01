import 'package:get/get.dart';

import 'connectivity_controller.dart';

class ConnectivityChecker {
  static ConnectivityController checkConnection(bool displayAlert) {
    final ConnectivityController connectivityController =
        Get.find<ConnectivityController>();
    connectivityController.updateDisplayAlert(displayAlert);
    return connectivityController;
  }
}
