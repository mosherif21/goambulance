import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../firebase_files/firebase_access.dart';
import '../../../../general/common_functions.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';

class RegisterUserDataPage extends StatelessWidget {
  const RegisterUserDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FirebaseDataAccess());
    return Scaffold(
      body: Center(
        child: RegularElevatedButton(
          buttonText: 'logout'.tr,
          onPressed: () async => logout(),
          enabled: true,
        ),
      ),
    );
  }
}
