import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../../general/common_widgets/custom_rolling_switch.dart';
import '../../../../general/common_widgets/dropdown_list.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../general/common_widgets/regular_card.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../../general/common_widgets/text_form_field_multiline.dart';
import '../../../../general/common_widgets/text_header.dart';
import '../../controllers/register_user_data_controller.dart';
import '../models.dart';
import 'add_disease.dart';
import 'medical_history_item.dart';
import 'no_medical_history.dart';

class MedicalHistoryInsertPage extends StatelessWidget {
  const MedicalHistoryInsertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = RegisterUserDataController.instance;
    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              controller: controller.medicalHistoryScrollController,
              child: Column(
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
                          DropdownList(
                            dropDownController:
                                controller.bloodTypeDropdownController,
                            items: bloodTypes,
                            hintText: 'pickBloodType'.tr,
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
                            headerText: 'askDiabetic'.trParams({
                              'ask': 'askYou'.tr,
                            }),
                            fontSize: 18),
                        const SizedBox(height: 5.0),
                        DropdownList(
                          dropDownController:
                              controller.diabetesDropdownController,
                          items: [
                            'no'.tr,
                            'Type 1',
                            'Type 2',
                          ],
                          hintText: 'no'.tr,
                        ),
                      ],
                    ),
                  ),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(
                            headerText: 'askHypertensivePatient'.trParams({
                              'ask': 'askYou'.tr,
                            }),
                            fontSize: 18),
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
                                  controller.hypertensivePatient = state,
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
                            headerText: 'askHeartPatient'.trParams({
                              'ask': 'askYou'.tr,
                            }),
                            fontSize: 18),
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
                  RegularCard(
                    highlightRed: false,
                    child: Obx(
                      () => SingleChildScrollView(
                        child: controller.diseasesList.isNotEmpty
                            ? Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: AutoSizeText(
                                      'addedDiseases'.tr,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  for (var diseaseItem
                                      in controller.diseasesList)
                                    MedicalHistoryItem(
                                        diseaseItem: diseaseItem,
                                        onDeletePressed: () {
                                          controller.diseasesList
                                              .remove(diseaseItem);
                                          if (controller.diseasesList.isEmpty) {
                                            Future.delayed(const Duration(
                                                    milliseconds: 50))
                                                .whenComplete(
                                              () => controller
                                                  .medicalHistoryScrollController
                                                  .animateTo(
                                                controller
                                                    .medicalHistoryScrollController
                                                    .position
                                                    .maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 700),
                                                curve: Curves.easeIn,
                                              ),
                                            );
                                          }
                                        }),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: RoundedElevatedButton(
                                      buttonText: 'addAllergiesOrDiseases'.tr,
                                      onPressed: () => RegularBottomSheet
                                          .showRegularBottomSheet(
                                        AddDisease(controller: controller),
                                      ),
                                      enabled: true,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            : NoMedicalHistory(controller: controller),
                      ),
                    ),
                  ),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(
                            headerText: 'enterAdditionalInformation'.tr,
                            fontSize: 18),
                        const SizedBox(height: 5.0),
                        TextFormFieldMultiline(
                          labelText: 'additionalInformation'.tr,
                          hintText: 'enterAdditionalInformation'.tr,
                          textController:
                              controller.additionalInformationTextController,
                          textInputAction: TextInputAction.done,
                          inputFormatter: LengthLimitingTextInputFormatter(150),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: RegularElevatedButton(
                      buttonText: 'save'.tr,
                      onPressed: () => controller.savePersonalInformation(),
                      enabled: true,
                      color: Colors.black,
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
