import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/firebase_files/firebase_access.dart';
import 'package:goambulance/src/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/features/authentication/screens/auth_screen.dart';
import 'package:goambulance/src/features/home_page/components/speech_to_text_test/speech_to_text.dart';
import 'package:goambulance/src/general/common_functions.dart';

import '../components/map/map_controllers/maps_controller.dart';
import '../components/map/widgets/google_map_widget.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    Get.put(MapsController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.75,
                child: const GoogleMapWidget(),
              ),
              const SizedBox(height: 20.0),
              RegularElevatedButton(
                  buttonText: 'logout'.tr,
                  onPressed: () async {
                    FirebaseDataAccess.instance.logout();
                    await AuthenticationRepository.instance
                        .logoutUser()
                        .whenComplete(() =>
                            Get.offAll(() => const AuthenticationScreen()));
                  },
                  enabled: true),
              const SizedBox(height: 20.0),
              RegularElevatedButton(
                  buttonText: 'SPEECH TO TEXT TEST',
                  onPressed: () {
                    Get.to(() => const SpeechToTextWidget());
                  },
                  enabled: true),
            ],
          ),
        ),
      ),
    );
  }
}
