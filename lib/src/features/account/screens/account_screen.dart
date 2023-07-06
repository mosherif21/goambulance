import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/general/common_widgets/link_account_button.dart';

import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_clickable_card_no_photo.dart';
import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../general/general_functions.dart';
import '../../authentication/components/emailChange/email_change_page.dart';
import '../../authentication/components/linkEmailPassword/link_email_password_page.dart';
import '../../authentication/components/resetPassword/logged_in_reset_password_page.dart';
import '../components/addresses/addresses_page.dart';
import '../components/critical_user/criticalUserRequestPage.dart';
import '../components/critical_user/sos_settings_page.dart';
import '../components/edit_account/edit_medical_history_page.dart';
import '../components/edit_account/edit_user_data_page.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

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
                                () => const EditUserDataPage(),
                                transition: getPageTransition(),
                              );
                              break;
                            case 1:
                              Get.to(
                                () => const AccountAddressesPage(),
                                transition: getPageTransition(),
                              );
                              break;
                            case 2:
                              Get.to(
                                () => const EditMedicalHistoryPage(),
                                transition: getPageTransition(),
                              );
                              break;
                            case 3:
                              getToPhoneVerificationScreen(
                                  linkWithPhone: true, goToInitPage: false);
                              break;
                          }
                        },
                        title: 'accountTitle${count + 1}'.tr,
                        subTitle: '',
                        icon: Icons.arrow_forward_ios,
                        iconColor: Colors.black45,
                      );
                    },
                    itemCount: 4,
                    shrinkWrap: true,
                  ),
                  Obx(
                    () => authRepo.isEmailAndPasswordLinked.value
                        ? const SizedBox.shrink()
                        : RegularClickableCardNoP(
                            onPressed: () => Get.to(
                                () => const LinkEmailPasswordPage(),
                                transition: getPageTransition()),
                            title: 'accountTitle5'.tr,
                            subTitle: '',
                            icon: Icons.arrow_forward_ios,
                            iconColor: Colors.black45,
                          ),
                  ),
                  Obx(
                    () => authRepo.isEmailAndPasswordLinked.value
                        ? Column(
                            children: [
                              RegularClickableCardNoP(
                                onPressed: () => Get.to(
                                    () => const EmailChangePage(),
                                    transition: getPageTransition()),
                                title: 'accountTitle7'.tr,
                                subTitle: '',
                                icon: Icons.arrow_forward_ios,
                                iconColor: Colors.black45,
                              ),
                              RegularClickableCardNoP(
                                onPressed: () => Get.to(
                                    () => const LoggedInResetPasswordPage(),
                                    transition: getPageTransition()),
                                title: 'accountTitle6'.tr,
                                subTitle: '',
                                icon: Icons.arrow_forward_ios,
                                iconColor: Colors.black45,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => !(authRepo.criticalUserStatus.value ==
                            CriticalUserStatus.criticalUserAccepted)
                        ? RegularClickableCardNoP(
                            onPressed: () => Get.to(
                                () => const CriticalUserRequestPage(),
                                transition: getPageTransition()),
                            title: 'requestCritical'.tr,
                            subTitle: '',
                            icon: Icons.arrow_forward_ios,
                            iconColor: Colors.black45,
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => (authRepo.criticalUserStatus.value ==
                            CriticalUserStatus.criticalUserAccepted)
                        ? RegularClickableCardNoP(
                            onPressed: () => Get.to(
                                () => const SOSRequestSettings(),
                                transition: getPageTransition()),
                            title: 'sosRequestSettings'.tr,
                            subTitle: '',
                            icon: Icons.arrow_forward_ios,
                            iconColor: Colors.black45,
                          )
                        : const SizedBox.shrink(),
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
                  /*  Obx(
                    () => authRepo.isFacebookLinked.value
                        ? const SizedBox.shrink()
                        : LinkAccountButton(
                            buttonText: 'linkFacebookAccount'.tr,
                            imagePath: kFacebookImg,
                            onPressed: () => authRepo.linkWithFacebook(),
                            backgroundColor: Colors.blueAccent,
                            textColor: Colors.white,
                            enabled: true,
                          ),
                  ),*/
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
