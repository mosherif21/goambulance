import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/account/controllers/register_user_data_controller.dart';
import 'package:goambulance/src/general/common_functions.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';

import '../../../../../firebase_files/firebase_access.dart';

class RegisterUserDataPage extends StatelessWidget {
  const RegisterUserDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FirebaseDataAccess());
    final controller = Get.put(RegisterUserDataController());
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Text(
                'enterYourInfo'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              TextFormFieldRegular(
                labelText: 'fullName'.tr,
                hintText: 'enterFullName'.tr,
                prefixIconData: Icons.person,
                textController: controller.nameTextController,
                inputType: InputType.text,
              ),
              SizedBox(height: screenHeight * 0.03),
              TextFormFieldRegular(
                labelText: '',
                hintText: '',
                prefixIconData: Icons.person,
                textController: controller.nameTextController,
                inputType: InputType.text,
              ),
              SizedBox(height: screenHeight * 0.03),
              TextFormFieldRegular(
                labelText: '',
                hintText: '',
                prefixIconData: Icons.person,
                textController: controller.nameTextController,
                inputType: InputType.text,
              ),
              // RegularElevatedButton(
              //   buttonText: 'logout'.tr,
              //   onPressed: () async => logout(),
              //   enabled: true,
              //   color: Colors.black,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
