import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';

import '../../../general/general_functions.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('account'),
          RegularElevatedButton(
            buttonText: 'logout'.tr,
            onPressed: () async => logout(),
            enabled: true,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
