import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../firebase_files/firebase_access.dart';

class RegisterUserDataPage extends StatelessWidget {
  const RegisterUserDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FirebaseDataAccess());
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // RegularElevatedButton(
            //   buttonText: 'logout'.tr,
            //   onPressed: () async => logout(),
            //   enabled: true,
            //   color: Colors.black,
            // ),
          ],
        ),
      ),
    );
  }
}
