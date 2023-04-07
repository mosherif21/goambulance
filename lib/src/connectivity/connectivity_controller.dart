import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lottie/lottie.dart';

import '../general/common_widgets/no_button_alert_dialog.dart';

class ConnectivityController extends GetxController {
  static ConnectivityController get instance => Get.find();
  late StreamSubscription _internetSubscription;
  late bool _displayAlert = false;
  late bool _isAlertDisplayed = false;
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void onInit() {
    super.onInit();
    //_initConnectivity();
    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
    //   (result) => _updateConnectivityStatus(result),
    // );
    _internetSubscription =
        InternetConnectionCheckerPlus().onStatusChange.listen(
              (status) => _checkInternet(status),
            );
  }

  void _checkInternet(InternetConnectionStatus internetConnectionStatus) {
    if (internetConnectionStatus == InternetConnectionStatus.connected ||
        AppInit.isWeb) {
      if (kDebugMode) print('Connected to internet');
      if (_isAlertDisplayed) _hideNetworkAlertDialog();
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
    if (Get.isDialogOpen == true) Get.back();
  }

  void _showNetworkAlertDialog() {
    final double? screenHeight = Get.context?.height;
    _isAlertDisplayed = true;
    NoButtonAlertDialog(
      title: 'noConnectionAlertTitle'.tr,
      content: Lottie.asset(
        kNoInternetAnim,
        fit: BoxFit.contain,
        height: screenHeight! * 0.25,
      ),
      dismissible: false,
    ).showNoButtonAlertDialog();
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
