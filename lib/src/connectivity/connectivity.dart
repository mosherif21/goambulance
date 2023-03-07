import 'connectivity_controller.dart';

class ConnectivityChecker {
  static ConnectivityController checkConnection({required bool displayAlert}) {
    final ConnectivityController connectivityController =
        ConnectivityController.instance;
    connectivityController.updateDisplayAlert(displayAlert);
    return connectivityController;
  }
}
