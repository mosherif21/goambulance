import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import '../../authentication/screens/auth_screen.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              RegularElevatedButton(
                  buttonText: 'logout'.tr,
                  onPressed: () async {
                    await AuthenticationRepository.instance
                        .logoutUser()
                        .whenComplete(() =>
                            Get.offAll(() => const AuthenticationScreen()));
                  },
                  enabled: true),
            ],
          ),
        ),
      ),
    );
  }
}
