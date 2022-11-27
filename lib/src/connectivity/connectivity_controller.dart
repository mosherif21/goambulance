import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../common_widgets/no_button_dialog_alert.dart';
import '../routing/splash_screen.dart';

class ConnectivityController extends GetxController {
  RxBool isInternetConnected = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late StreamSubscription _internetSubscription;
  late BuildContext _context;
  late double _screenHeight;
  late bool _displayAlert = false;
  late bool _isAlertDisplayed = false;
  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _initInternetCheck();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        _updateConnectivityStatus(result);
      },
    );
    _internetSubscription = InternetConnectionChecker().onStatusChange.listen(
      (status) {
        _checkInternet(status);
      },
    );
  }

  Future<void> _checkInternet(
      InternetConnectionStatus internetConnectionStatus) async {
    if (AppInit.isWeb) {
      isInternetConnected.value = true;
    } else {
      if (internetConnectionStatus == InternetConnectionStatus.connected) {
        isInternetConnected.value = true;
        if (_isAlertDisplayed && _displayAlert) _hideNetworkAlertDialog();
      } else if (internetConnectionStatus ==
          InternetConnectionStatus.disconnected) {
        isInternetConnected.value = false;
      }
    }
    if (!isInternetConnected.value) {
      removeSplash();
      if (!_isAlertDisplayed && _displayAlert) {
        _showNetworkAlertDialog();
      }
    } else {
      await AppInit.initialize();
    }
  }

  void _hideNetworkAlertDialog() {
    _isAlertDisplayed = false;
    Navigator.pop(_context);
  }

  void _showNetworkAlertDialog() {
    _isAlertDisplayed = true;
    NoButtonDialogAlert(
      title: 'noConnectionAlertTitle'.tr,
      content: Image.asset(
        kNoInternetAnim,
        height: _screenHeight * 0.2,
      ),
      context: _context,
      dismissible: false,
    ).showNoButtonAlertDialog();
  }

  void updateContext(
      BuildContext context, double screenHeight, bool displayAlert) {
    _context = context;
    _screenHeight = screenHeight;
    _displayAlert = displayAlert;
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result;
    result = await _connectivity.checkConnectivity();
    return _updateConnectivityStatus(result);
  }

  Future<void> _initInternetCheck() async {
    InternetConnectionStatus internetConnectionStatus;
    internetConnectionStatus =
        await InternetConnectionChecker().connectionStatus;
    return _checkInternet(internetConnectionStatus);
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        break;
      case ConnectivityResult.mobile:
        break;
      case ConnectivityResult.ethernet:
        break;
      case ConnectivityResult.none:
        break;
      default:
        if (kDebugMode) print("failed to get network type");
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
    _internetSubscription.cancel();
  }
}
