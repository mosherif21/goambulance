import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/models.dart';

import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/common_widgets/framed_text.dart';
import '../../../../../general/common_widgets/regular_clickable_card_icon.dart';
import '../../../../../general/general_functions.dart';

class EmployeeUserInformationPage extends StatelessWidget {
  const EmployeeUserInformationPage({
    super.key,
    required this.userInfo,
  });

  final UserInfoRequestModel userInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'userInformation'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Center(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: userInfo.profilePicUrl.isNotEmpty
                                ? Colors.grey.shade300
                                : Colors.white,
                            backgroundImage: userInfo.profilePicUrl.isNotEmpty
                                ? NetworkImage(userInfo.profilePicUrl)
                                : null,
                            child: userInfo.profilePicUrl.isNotEmpty
                                ? null
                                : const Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              userInfo.name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (userInfo.criticalUser)
                            FramedText(
                              text: 'criticalUser'.tr,
                              color: Colors.red,
                              fontSize: 15,
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          AutoSizeText(
                            '${'emailLabel'.tr}: ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          Flexible(
                            child: AutoSizeText(
                              userInfo.email,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          AutoSizeText(
                            '${'age'.tr}: ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          Flexible(
                            child: AutoSizeText(
                              '${userInfo.age}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          AutoSizeText(
                            '${'gender'.tr}: ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            userInfo.gender == 'male' ? 'male'.tr : 'female'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Divider(
                  thickness: 8,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: AutoSizeText(
                    'contactInformation'.tr,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 20),
                RegularClickableCardIcon(
                  onPressed: () =>
                      callNumber(phoneNumber: userInfo.phoneNumber),
                  title: 'phoneNumber'.tr,
                  subTitle: userInfo.phoneNumber,
                  leadingIcon: Icons.phone_android,
                  trailingIcon: Icons.phone,
                  trailingIconColor: Colors.green,
                  leadingIconColor: Colors.black,
                ),
                if (userInfo.backupNumber.isNotEmpty &&
                    userInfo.backupNumber != 'null')
                  RegularClickableCardIcon(
                    onPressed: () =>
                        callNumber(phoneNumber: userInfo.backupNumber),
                    title: 'backupPhoneNumber'.tr,
                    subTitle: userInfo.backupNumber,
                    leadingIcon: Icons.contact_phone,
                    trailingIcon: Icons.phone,
                    trailingIconColor: Colors.green,
                    leadingIconColor: Colors.black,
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
