import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/features/login/components/alternate_login_buttons.dart';

import '../../../connectivity/connectivity.dart';
import '../../../connectivity/connectivity_controller.dart';
import '../../../constants/assets_strings.dart';
import '../components/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    ConnectivityController connectivityController =
        ConnectivityChecker.checkConnection(context, screenHeight, true);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPaddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage(kLogoImageWithSlogan),
                  height: screenHeight * 0.25,
                ),
                const SizedBox(height: 10),
                LoginForm(height: screenHeight),
                AlternateLoginButtons(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
