import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/controllers/edit_medical_history_controller.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../general/common_widgets/custom_rolling_switch.dart';
import '../../../general/common_widgets/dropdown_list.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/common_widgets/regular_card.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../general/common_widgets/text_form_field_multiline.dart';
import '../../../general/common_widgets/text_header.dart';
import 'loading_medical_diseases.dart';
import 'models.dart';
import 'newAccount/add_disease.dart';
import 'newAccount/medical_history_item.dart';
import 'newAccount/no_medical_history.dart';

class EditMedicalHistoryPage extends StatelessWidget {
  const EditMedicalHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditMedicalHistoryController());
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
                    'editMedicalHistory'.tr,
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
                              keyInternal: controller.hypertensiveKey,
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
                              keyInternal: controller.heartPatientKey,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => RegularCard(
                      highlightRed: false,
                      child: SingleChildScrollView(
                        child: !controller.diseasesLoaded.value
                            ? const LoadingMedicalDiseases()
                            : controller.diseasesList.isNotEmpty
                                ? Column(
                                    children: [
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
                                      const SizedBox(height: 10),
                                      for (var diseaseItem
                                          in controller.diseasesList)
                                        MedicalHistoryItem(
                                          diseaseItem: diseaseItem,
                                          onDeletePressed: () => controller
                                              .diseasesList
                                              .remove(diseaseItem),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: RoundedElevatedButton(
                                          buttonText:
                                              'addAllergiesOrDiseases'.tr,
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
                  const SizedBox(height: 10.0),
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
                      onPressed: () => controller.updateMedicalInfo(),
                      enabled: true,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
