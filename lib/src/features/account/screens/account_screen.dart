import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../general/common_widgets/regular_clickable_card_no_photo.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import '../../../general/general_functions.dart';
import '../components/addresses_page.dart';
import '../components/edit_medical_history_page.dart';
import '../components/edit_user_data_page.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        scrolledUnderElevation: 5,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
                              Get.to(() => const EditUserDataPage());
                              break;
                            case 1:
                              Get.to(() => const AccountAddressesPage());
                              break;
                            case 2:
                              Get.to(() => const EditMedicalHistoryPage());
                              break;
                          }
                        },
                        title: 'accountTitle${count + 1}'.tr,
                        subTitle: '',
                        icon: Icons.arrow_forward_ios,
                        iconColor: Colors.black45,
                      );
                    },
                    itemCount: 3,
                    shrinkWrap: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SignInButton(
                          padding: const EdgeInsets.only(left: 5.0),
                          Buttons.GoogleDark,
                          text: 'linkGoogle'.tr,
                          onPressed: () async {
                            showLoadingScreen();
                            final returnMessage = await AuthenticationRepository
                                .instance
                                .signInWithGoogle();
                            if (returnMessage.compareTo('success') != 0) {
                              hideLoadingScreen();
                            }
                          },
                          width: getScreenWidth(context) - 100,
                          height: 50.0,
                        )
                      ],
                    ),
                  ),
                  RegularElevatedButton(
                    buttonText: 'logout'.tr,
                    onPressed: () async => logoutDialogue(),
                    enabled: true,
                    color: Colors.black,
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
