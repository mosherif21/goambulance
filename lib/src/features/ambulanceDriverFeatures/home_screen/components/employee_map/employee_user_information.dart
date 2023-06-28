import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/components/models.dart';

import '../../../../../general/common_widgets/framed_text.dart';

class EmployeeUserInformationWidget extends StatelessWidget {
  const EmployeeUserInformationWidget({
    super.key,
    required this.profilePicUrl,
    required this.userInfo,
  });

  final String profilePicUrl;
  final UserInfoRequestModel userInfo;
  @override
  Widget build(BuildContext context) {
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Center(
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: profilePicUrl.isNotEmpty
                            ? Colors.grey.shade300
                            : Colors.white,
                        backgroundImage: profilePicUrl.isNotEmpty
                            ? NetworkImage(profilePicUrl)
                            : null,
                        child: profilePicUrl.isNotEmpty
                            ? null
                            : const Icon(Icons.person),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AutoSizeText(
                        userInfo.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      if (userInfo.criticalUser)
                        FramedText(
                          text: 'criticalUser'.tr,
                          color: Colors.red,
                          fontSize: 15,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: AutoSizeText(
                    'help'.tr,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
