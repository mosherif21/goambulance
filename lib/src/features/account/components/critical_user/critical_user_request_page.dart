import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:lottie/lottie.dart';

import '../../../../../firebase_files/firebase_patient_access.dart';
import '../../../../constants/assets_strings.dart';
import '../../../../constants/enums.dart';
import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/rounded_elevated_button.dart';

class CriticalUserRequestPage extends StatelessWidget {
  const CriticalUserRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final authRepo = AuthenticationRepository.instance;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'requestCritical'.tr,
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Lottie.asset(
                      kSOSAnim,
                      fit: BoxFit.contain,
                      height: screenHeight * 0.35,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AutoSizeText(
                    'criticalUserRequestBody'.tr,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 8,
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => RoundedElevatedButton(
                      buttonText: authRepo.criticalUserStatus.value ==
                              CriticalUserStatus.criticalUserPending
                          ? 'criticalUserRequested'.tr
                          : authRepo.criticalUserStatus.value ==
                                  CriticalUserStatus.criticalUserDenied
                              ? 'criticalUserDenied'.tr
                              : authRepo.criticalUserStatus.value ==
                                      CriticalUserStatus.criticalUserAccepted
                                  ? 'criticalRequestAccepted'.tr
                                  : 'sendRequest'.tr,
                      onPressed: () async {
                        showLoadingScreen();
                        final functionStatus = await FirebasePatientDataAccess
                            .instance
                            .sendCriticalUserRequest();
                        hideLoadingScreen();
                        if (functionStatus == FunctionStatus.success) {
                          authRepo.criticalUserStatus.value =
                              CriticalUserStatus.criticalUserPending;
                          showSnackBar(
                              text: 'criticalUserRequestSent'.tr,
                              snackBarType: SnackBarType.success);
                        } else {
                          showSnackBar(
                              text: 'criticalUserRequestFailed'.tr,
                              snackBarType: SnackBarType.error);
                        }
                      },
                      enabled: authRepo.criticalUserStatus.value ==
                              CriticalUserStatus.criticalUserPending
                          ? false
                          : authRepo.criticalUserStatus.value ==
                                  CriticalUserStatus.criticalUserDenied
                              ? false
                              : authRepo.criticalUserStatus.value ==
                                      CriticalUserStatus.criticalUserAccepted
                                  ? false
                                  : true,
                      color: Colors.red,
                    ),
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
