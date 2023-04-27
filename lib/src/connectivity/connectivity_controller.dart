import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../general/general_functions.dart';

class ConnectivityController extends GetxController {
  static ConnectivityController get instance => Get.find();
  late StreamSubscription _internetSubscription;
  late bool _displayAlert = false;
  late bool _isAlertDisplayed = false;
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void onInit() {
    //_initConnectivity();
    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
    //   (result) => _updateConnectivityStatus(result),
    // );
    _internetSubscription =
        InternetConnectionCheckerPlus().onStatusChange.listen(
              (status) => _checkInternet(status),
            );
    super.onInit();
  }

  void _checkInternet(InternetConnectionStatus internetConnectionStatus) {
    if (internetConnectionStatus == InternetConnectionStatus.connected ||
        AppInit.isWeb) {
      if (kDebugMode) print('Connected to internet');
      //if (_isAlertDisplayed) _hideNetworkAlertDialog();
      AppInit.internetInitialize();
    } else if (internetConnectionStatus ==
        InternetConnectionStatus.disconnected) {
      if (!_isAlertDisplayed && _displayAlert) _showNetworkAlertDialog();
      if (kDebugMode) print('Disconnected from internet');
      AppInit.noInternetInitializeCheck();
    }
  }

  void _hideNetworkAlertDialog() {
    _isAlertDisplayed = false;
    Get.back();
  }

  void _showNetworkAlertDialog() {
    _isAlertDisplayed = true;
    displayAlertDialog(
      title: 'noConnectionAlertTitle'.tr,
      body: 'noConnectionAlertContent'.tr,
      color: SweetSheetColor.DANGER,
      positiveButtonText: 'ok'.tr,
      positiveButtonOnPressed: () => _hideNetworkAlertDialog(),
      mainIcon: Icons.signal_wifi_statusbar_connected_no_internet_4,
      isDismissible: false,
    );
  }

  void updateDisplayAlert({required bool displayAlert}) {
    _displayAlert = displayAlert;
  }

  // Future<void> _initConnectivity() async {
  //   ConnectivityResult result;
  //   result = await _connectivity.checkConnectivity();
  //   return _updateConnectivityStatus(result);
  // }
  //
  // void _updateConnectivityStatus(ConnectivityResult result) {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //       break;
  //     case ConnectivityResult.mobile:
  //       break;
  //     case ConnectivityResult.ethernet:
  //       break;
  //     case ConnectivityResult.none:
  //       break;
  //     default:
  //       if (kDebugMode) print("failed to get network type");
  //       break;
  //   }
  // }

  @override
  void onClose() {
    super.onClose();
    //_connectivitySubscription.cancel();
    _internetSubscription.cancel();
  }
}
