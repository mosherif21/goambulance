import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';

import '../../../../../general/common_widgets/back_button.dart';

class EmployeeMedicalInformationPage extends StatelessWidget {
  const EmployeeMedicalInformationPage({
    super.key,
    required this.medicalInfo,
  });

  final MedicalHistoryModel medicalInfo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'medicalInformation'.tr,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      AutoSizeText(
                        '${'bloodType'.tr}: ${medicalInfo.bloodType != 'unknown' ? medicalInfo.bloodType : 'unknown'.tr}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10),
                      AutoSizeText(
                        '${'hypertensive'.tr}: ${medicalInfo.hypertensive != 'unknown' ? medicalInfo.hypertensive == 'No' ? 'no'.tr : 'yes'.tr : 'unknown'.tr}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10),
                      AutoSizeText(
                        '${'diabetic'.tr}: ${medicalInfo.diabetic != 'unknown' ? medicalInfo.diabetic == 'No' ? 'no'.tr : medicalInfo.diabetic : 'unknown'.tr}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10),
                      AutoSizeText(
                        '${'heartPatient'.tr}: ${medicalInfo.heartPatient != 'unknown' ? medicalInfo.heartPatient == 'No' ? 'no'.tr : 'yes'.tr : 'unknown'.tr}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      // const SizedBox(height: 10),
                      // AutoSizeText(
                      //   '${'medicalAdditionalInformation'.tr}: ${userInfo.email}',
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.w700,
                      //     color: Colors.black,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      //   maxLines: 1,
                      // ),
                      // AutoSizeText(
                      //   '${'additionalInformation'.tr}: ${userInfo.email}',
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.w700,
                      //     color: Colors.black,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      //   maxLines: 1,
                      // ),
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
                    'diseases'.tr,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
