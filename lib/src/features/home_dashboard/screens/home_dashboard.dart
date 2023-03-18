import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/features/authentication/screens/auth_screen.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Dashboard'),
            RegularElevatedButton(
              buttonText: 'logout'.tr,
              onPressed: () async => await AuthenticationRepository.instance
                  .logoutUser()
                  .whenComplete(
                      () => Get.offAll(() => const AuthenticationScreen())),
              enabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
