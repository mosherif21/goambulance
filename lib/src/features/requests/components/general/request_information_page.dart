import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/general_functions.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../general/common_widgets/back_button.dart';
import '../models.dart';
import 'disease_item_request_info.dart';

class RequestInformationPage extends StatelessWidget {
  const RequestInformationPage({
    super.key,
    required this.requestInfo,
  });

  final RequestInfoModel requestInfo;

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'requestInformation'.tr,
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
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            requestInfo.medicalHistory!.bloodType != 'unknown'
                                ? requestInfo.medicalHistory!.bloodType
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
                              requestInfo.medicalHistory!.hypertensive !=
                                      'unknown'
                                  ? requestInfo.medicalHistory!.hypertensive ==
                                          'No'
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
                              requestInfo.medicalHistory!.heartPatient !=
                                      'unknown'
                                  ? requestInfo.medicalHistory!.heartPatient ==
                                          'No'
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
                              requestInfo.medicalHistory!.diabetic != 'unknown'
                                  ? requestInfo.medicalHistory!.diabetic == 'No'
                                      ? 'no'.tr
                                      : requestInfo.medicalHistory!.diabetic
                                  : 'unknown'.tr,
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
                              requestInfo.patientCondition,
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
                            '${'patientAge'.tr}:',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: AutoSizeText(
                              requestInfo.patientAge,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                            requestInfo.medicalHistory!.medicalAdditionalInfo
                                    .isEmpty
                                ? 'noAdditionalInformation'.tr
                                : requestInfo
                                    .medicalHistory!.medicalAdditionalInfo,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
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
                      requestInfo.medicalHistory!.diseasesList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  for (var diseaseItem in requestInfo
                                      .medicalHistory!.diseasesList)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
