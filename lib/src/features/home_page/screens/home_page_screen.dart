import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import '../../authentication/screens/auth_screen.dart';
import '../components/speech_to_text_test/speech_to_text.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: <Widget>[
            RegularElevatedButton(
                buttonText: 'logout'.tr,
                onPressed: () async {
                  await AuthenticationRepository.instance
                      .logoutUser()
                      .whenComplete(
                          () => Get.offAll(() => const AuthenticationScreen()));
                },
                enabled: true),
            RegularElevatedButton(
                buttonText: 'speech',
                onPressed: () async {
                  Get.offAll(() => const SpeechToTextWidget());
                },
                enabled: true),
          ],
        ),
      ),
    );
  }
}
