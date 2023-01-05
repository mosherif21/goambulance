import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/features/authentication/screens/login_screen.dart';
import 'package:goambulance/src/general/common_functions.dart';

import '../components/map/map_controllers/maps_controller.dart';
import '../components/map/widgets/abstract_map_widget.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    //final mapsController =
    Get.put(MapsController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.8,
                child: MapWidget(),
              ),
              const SizedBox(height: 20.0),
              RegularElevatedButton(
                  buttonText: 'logout'.tr,
                  onPressed: () async {
                    await AuthenticationRepository.instance
                        .logoutUser()
                        .then((value) => Get.offAll(() => const LoginScreen()));
                  },
                  enabled: true),
            ],
          ),
        ),
      ),
    );
  }
}
