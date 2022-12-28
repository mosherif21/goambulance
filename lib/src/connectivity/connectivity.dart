import 'connectivity_controller.dart';

class ConnectivityChecker {
  static ConnectivityController checkConnection(bool displayAlert) {
    final ConnectivityController connectivityController =
        ConnectivityController.instance;
    connectivityController.updateDisplayAlert(displayAlert);
    return connectivityController;
  }
}
