import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:lottie/lottie.dart';

import '../../../../../firebase_files/firebase_patient_access.dart';
import '../../../../constants/assets_strings.dart';
import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/rounded_elevated_button.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'deleteAccount'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Lottie.asset(
                      kDeleteAnim,
                      fit: BoxFit.contain,
                      height: screenHeight * 0.35,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AutoSizeText(
                    'deleteAccountBody'.tr,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 8,
                  ),
                  const SizedBox(height: 30),
                  RoundedElevatedButton(
                    buttonText: 'deleteAccount'.tr,
                    onPressed: () =>
                        FirebasePatientDataAccess.instance.onDeleteUserPress(),
                    enabled: true,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
