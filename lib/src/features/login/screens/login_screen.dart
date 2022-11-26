import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/sizes.dart';

import '../../../../connectivity/connectivity_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    final ConnectivityController connectivityController =
        Get.find<ConnectivityController>();
    connectivityController.updateContext(context, height, true);
    connectivityController.checkShowNetworkDialog();
    FlutterNativeSplash.remove();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Obx(
            () => connectivityController.isInternetConnected.value
                ? Container(
                    padding: const EdgeInsets.all(kDefaultPaddingSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SignInButton(
                          Buttons.GoogleDark,
                          text: "Sign up with Google",
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
