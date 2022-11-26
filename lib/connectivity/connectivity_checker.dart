import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkChecker {
  late StreamSubscription subscription;
  RxBool isDeviceConnected = false.obs;
  RxBool isNetworkAlertDisplayed = false.obs;
  static late BuildContext context;
  checkConnectivity() async =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected.value =
              await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected.value && !isNetworkAlertDisplayed.value) {
            isNetworkAlertDisplayed.value = true;
            showNetworkAlertDialog();
          }
        },
      );

  void showNetworkAlertDialog() {
    // SingleButtonDialogAlert(
    //  'No Connection',
    //  );
  }
}
