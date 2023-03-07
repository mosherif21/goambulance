import 'connectivity_controller.dart';

class ConnectivityChecker {
  static void checkConnection({required bool displayAlert}) =>
      ConnectivityController.instance.updateDisplayAlert(displayAlert);
}
