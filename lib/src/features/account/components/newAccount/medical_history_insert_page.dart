import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../../constants/colors.dart';
import '../../../../general/common_widgets/custom_rolling_switch.dart';
import '../../../../general/common_widgets/dropdown_list_custom.dart';
import '../../../../general/common_widgets/regular_card.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/common_widgets/text_header.dart';
import '../../controllers/register_user_data_controller.dart';
import 'no_medical_history.dart';

class MedicalHistoryInsertPage extends StatelessWidget {
  const MedicalHistoryInsertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = RegisterUserDataController.instance;
    // final screenHeight = getScreenHeight(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RegularBackButton(padding: 0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    AutoSizeText(
                      'enterMedicalHistory'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20.0),
                    Obx(
                      () => RegularCard(
                        highlightRed: controller.highlightBloodType.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'chooseBloodType'.tr, fontSize: 18),
                            const SizedBox(height: 5.0),
                            CustomDropDown(
                              onValueChanged: (selectedBloodType) => controller
                                  .selectedBloodType
                                  .value = selectedBloodType as String,
                              items: bloodTypes,
                              dropDownValue:
                                  controller.selectedBloodType.value.isNotEmpty
                                      ? controller.selectedBloodType.value
                                      : 'pickBloodType'.tr,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => RegularCard(
                        highlightRed: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'askDiabetic'.tr, fontSize: 18),
                            const SizedBox(height: 5.0),
                            CustomDropDown(
                              onValueChanged: (selectedDiabetesType) =>
                                  controller.diabeticType.value =
                                      selectedDiabetesType as String,
                              items: diabetesTypes,
                              dropDownValue:
                                  controller.diabeticType.value.isNotEmpty
                                      ? controller.diabeticType.value
                                      : 'no'.tr,
                            ),
                          ],
                        ),
                      ),
                    ),
                    RegularCard(
                      highlightRed: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader(
                              headerText: 'askBloodPressurePatient'.tr,
                              fontSize: 12),
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              const Spacer(),
                              CustomRollingSwitch(
                                onText: 'yes'.tr,
                                offText: 'no'.tr,
                                onIcon: Icons.check,
                                offIcon: Icons.close,
                                onSwitched: (bool state) =>
                                    controller.bloodPressurePatient = state,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    RegularCard(
                      highlightRed: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader(
                              headerText: 'askHeartPatient'.tr, fontSize: 12),
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              const Spacer(),
                              CustomRollingSwitch(
                                onText: 'yes'.tr,
                                offText: 'no'.tr,
                                onIcon: Icons.check,
                                offIcon: Icons.close,
                                onSwitched: (bool state) =>
                                    controller.heartPatient = state,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: const SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child:
                            // Column(
                            //   children: [
                            //     for (int i = 0; i < 2; i++)
                            //       MedicalHistoryItem(
                            //         screenHeight: screenHeight,
                            //         item: DiseaseItem(
                            //           diseaseName: 'Blood pressure',
                            //           diseaseMedicine: 'micardis',
                            //         ),
                            //       )
                            //   ],
                            // ),
                            NoMedicalHistory(),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 15.0, right: 15.0),
                      child: RegularElevatedButton(
                        buttonText: 'addAllergiesOrDiseases'.tr,
                        onPressed: () {},
                        enabled: true,
                        color: kDefaultColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RegularElevatedButton(
                        buttonText: 'save'.tr,
                        onPressed: () async =>
                            await controller.savePersonalInformation(),
                        enabled: true,
                        color: kDefaultColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
