import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/single_button_dialog_alert.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

class ConnectivityController extends GetxController {
  RxInt connectionStatus = 0.obs;
  RxBool isInternetConnected = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late BuildContext context;
  late double screenHeight;
  late bool displayAlert = false;
  late bool isAlertDisplayed = false;
  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        _updateConnectivityStatus(result);
        await checkShowNetworkDialog();
      },
    );
  }

  Future<void> checkShowNetworkDialog() async {
    isInternetConnected.value = await InternetConnectionChecker().hasConnection;
    if (!isInternetConnected.value) {
      if (!isAlertDisplayed && displayAlert) {
        showNetworkAlertDialog();
      }
    } else {
      AppInit.initialize();
    }
  }

  void showNetworkAlertDialog() {
    isAlertDisplayed = true;
    SingleButtonDialogAlert(
      title: 'noConnectionAlertTitle'.tr,
      content: Lottie.asset(kNoInternetAnim,
          height: screenHeight * 0.2, frameRate: FrameRate.max),
      buttonText: 'OK'.tr,
      onPressed: () async {
        Navigator.pop(context);
        isAlertDisplayed = false;
        isInternetConnected.value =
            await InternetConnectionChecker().hasConnection;
        if (!isInternetConnected.value) {
          showNetworkAlertDialog();
        }
      },
      context: context,
      dismissible: false,
    ).showSingleButtonAlertDialog();
  }

  void updateContext(
      BuildContext context, double screenHeight, bool displayAlert) {
    this.context = context;
    this.screenHeight = screenHeight;
    this.displayAlert = displayAlert;
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    result = await _connectivity.checkConnectivity();
    return _updateConnectivityStatus(result);
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = 1;

        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 2;

        break;
      case ConnectivityResult.ethernet:
        connectionStatus.value = 3;

        break;
      case ConnectivityResult.none:
        connectionStatus.value = 0;

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
  }
}
