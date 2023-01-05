import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/features/authentication/screens/login_screen.dart';

import '../../../constants/app_init_constants.dart';
import '../../../error_widgets/not_available_error_widget.dart';
import '../components/map/google_maps.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppInit.isWeb
        ? const NotAvailableErrorWidget()
        : Scaffold(
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(kDefaultPaddingSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const GoogleMapWidget(),
                    const SizedBox(height: 20.0),
                    RegularElevatedButton(
                        buttonText: 'logout'.tr,
                        onPressed: () async {
                          await AuthenticationRepository.instance
                              .logoutUser()
                              .then((value) =>
                                  Get.offAll(() => const LoginScreen()));
                        },
                        enabled: true),
                  ],
                ),
              ),
            ),
          );
  }
}
