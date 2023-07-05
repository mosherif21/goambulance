import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/requests/components/general/disease_item_request_info.dart';
import 'package:lottie/lottie.dart';

import '../../../../../constants/assets_strings.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/general_functions.dart';

class EmployeeMedicalInformationPage extends StatelessWidget {
  const EmployeeMedicalInformationPage({
    super.key,
    required this.medicalInfo,
    required this.patientAge,
    required this.patientCondition,
  });

  final MedicalHistoryModel medicalInfo;
  final String patientAge;
  final String patientCondition;

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Lottie.asset(kMedicalInfoAnim,
                        fit: BoxFit.contain, height: screenHeight * 0.4),
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        '${'bloodType'.tr}: ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        medicalInfo.bloodType != 'unknown'
                            ? medicalInfo.bloodType
                            : 'unknown'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AutoSizeText(
                        '${'hypertensive'.tr}:',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          medicalInfo.hypertensive != 'unknown'
                              ? medicalInfo.hypertensive == 'No'
                                  ? 'no'.tr
                                  : 'yes'.tr
                              : 'unknown'.tr,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        '${'heartPatient'.tr}:',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          medicalInfo.heartPatient != 'unknown'
                              ? medicalInfo.heartPatient == 'No'
                                  ? 'no'.tr
                                  : 'yes'.tr
                              : 'unknown'.tr,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        '${'diabetic'.tr}:',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          medicalInfo.diabetic != 'unknown'
                              ? medicalInfo.diabetic == 'No'
                                  ? 'no'.tr
                                  : medicalInfo.diabetic
                              : 'unknown'.tr,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        '${'patientAge'.tr}:',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          patientAge,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AutoSizeText(
                        '${'conditionInformation'.tr}:',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          patientCondition,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        '${'additionalInformation'.tr}:',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      AutoSizeText(
                        medicalInfo.medicalAdditionalInfo.isEmpty
                            ? 'noAdditionalInformation'.tr
                            : medicalInfo.medicalAdditionalInfo,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
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
                  medicalInfo.diseasesList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              for (var diseaseItem in medicalInfo.diseasesList)
                                DiseaseItemRequest(
                                  diseaseItem: diseaseItem,
                                ),
                            ],
                          ),
                        )
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  kMedicalHistoryImg,
                                  height: screenHeight * 0.25,
                                ),
                                const SizedBox(height: 10),
                                AutoSizeText(
                                  'noMedicalHistory'.tr,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
