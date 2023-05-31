import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/assets_strings.dart';
import 'package:goambulance/src/general/common_widgets/link_account_button.dart';

import '../../../general/common_widgets/regular_clickable_card_no_photo.dart';
import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../general/general_functions.dart';
import '../../authentication/components/resetPassword/email_reset_screen.dart';
import '../components/addresses_page.dart';
import '../components/edit_medical_history_page.dart';
import '../components/edit_user_data_page.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final authRepo = AuthenticationRepository.instance;
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
        scrolledUnderElevation: 2,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
                            onPressed: () {},
                            title: 'accountTitle5'.tr,
                            subTitle: '',
                            icon: Icons.arrow_forward_ios,
                            iconColor: Colors.black45,
                          ),
                  ),
                  Obx(
                    () => !authRepo.isEmailAndPasswordLinked.value
                        ? const SizedBox.shrink()
                        : RegularClickableCardNoP(
                            onPressed: () {
                              getToResetPasswordScreen();
                            },
                            title: 'accountTitle6'.tr,
                            subTitle: '',
                            icon: Icons.arrow_forward_ios,
                            iconColor: Colors.black45,
                          ),
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
                  SizedBox(height: screenHeight * 0.1)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
