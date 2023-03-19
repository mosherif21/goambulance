import 'package:flutter/material.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';

import '../../../general/common_widgets/regular_elevated_button.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Dashboard'),
            RegularElevatedButton(
              buttonText: 'show drawer',
              onPressed: () {
                homeScreenController.toggleDrawer();
              },
              enabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
