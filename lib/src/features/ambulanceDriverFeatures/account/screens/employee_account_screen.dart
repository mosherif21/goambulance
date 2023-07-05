import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/general/common_widgets/link_account_button.dart';

import '../../../../general/common_widgets/regular_clickable_card_no_photo.dart';
import '../../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../../general/general_functions.dart';
import '../../../authentication/components/emailChange/email_change_page.dart';
import '../../../authentication/components/resetPassword/logged_in_reset_password_page.dart';
import '../components/edit_account/employee_account_details_page.dart';

class EmployeeAccountScreen extends StatelessWidget {
  const EmployeeAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          'account'.tr,
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
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemBuilder: (BuildContext context, int count) {
                      return RegularClickableCardNoP(
                        onPressed: () {
                          switch (count) {
                            case 0:
                              Get.to(
                                () => const EmployeeEditUserDataPage(),
                                transition: getPageTransition(),
                              );
                              break;
                            case 1:
                              getToPhoneVerificationScreen(
                                  linkWithPhone: true, goToInitPage: false);
                              break;
                            case 2:
                              Get.to(() => const EmailChangePage(),
                                  transition: getPageTransition());
                              break;
                            case 3:
                              Get.to(() => const LoggedInResetPasswordPage(),
                                  transition: getPageTransition());
                              break;
                          }
                        },
                        title: 'EmployeeAccountTitle${count + 1}'.tr,
                        subTitle: '',
                        icon: Icons.arrow_forward_ios,
                        iconColor: Colors.black45,
                      );
                    },
                    itemCount: 4,
                    shrinkWrap: true,
                  ),
                  Obx(
                    () => LinkAccountButton(
                      buttonText: authRepo.isGoogleLinked.value
                          ? 'changeGoogleAccount'.tr
                          : 'linkGoogleAccount'.tr,
                      imagePath: kGoogleImg,
                      onPressed: () => authRepo.linkWithGoogle(),
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      enabled: true,
                    ),
                  ),
                  Obx(
                    () => authRepo.isFacebookLinked.value
                        ? const SizedBox.shrink()
                        : LinkAccountButton(
                            buttonText: 'linkFacebookAccount'.tr,
                            imagePath: kFacebookImg,
                            onPressed: () {},
                            backgroundColor: Colors.blueAccent,
                            textColor: Colors.white,
                            enabled: true,
                          ),
                  ),
                  RoundedElevatedButton(
                    buttonText: 'logout'.tr,
                    onPressed: () => logoutDialogue(),
                    enabled: true,
                    color: Colors.red,
                  ),
                  SizedBox(height: screenHeight * 0.12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
