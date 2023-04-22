import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/dropdown_list.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../general/common_widgets/regular_card.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/common_widgets/text_form_field_multiline.dart';
import '../../../../general/common_widgets/text_header.dart';
import '../../../account/components/newAccount/add_disease.dart';
import '../../../account/components/newAccount/medical_history_item.dart';
import '../../../account/components/newAccount/no_medical_history.dart';
import '../../controllers/making_request_information_controller.dart';

class NormalRequestScreen extends StatelessWidget {
  const NormalRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MakingRequestInformationController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
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
              controller: controller.medicalHistoryScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5.0),
                  AutoSizeText(
                    'enterRequestInfo'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(headerText: 'requestFor'.tr, fontSize: 18),
                        const SizedBox(height: 5.0),
                        DropdownList(
                          dropdownController:
                              controller.requestTypeDropdownController,
                          itemsList: controller.requestTypeItems,
                          onChanged: (requestType) =>
                              controller.notUserRequest.value =
                                  requestType.compareTo('forMe'.tr) == 0
                                      ? false
                                      : true,
                        ),
                      ],
                    ),
                  ),
                  Obx(() => controller.notUserRequest.value
                      ? Column(
                          children: [
                            RegularCard(
                              highlightRed: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextHeader(
                                      headerText: 'chooseHisBloodType'.tr,
                                      fontSize: 18),
                                  const SizedBox(height: 5.0),
                                  DropdownList(
                                    dropdownController:
                                        controller.bloodTypeDropdownController,
                                    itemsList: controller.bloodTypeItems,
                                    onChanged: (bloodTypeChoose) => controller
                                        .selectedBloodType = bloodTypeChoose,
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
                                      headerText: 'askDiabetic'.trParams({
                                        'ask': 'askHim'.tr,
                                      }),
                                      fontSize: 18),
                                  const SizedBox(height: 5.0),
                                  DropdownList(
                                    dropdownController:
                                        controller.diabetesDropdownController,
                                    itemsList: controller.diabetesItems,
                                    onChanged: (diabeticValue) =>
                                        controller.diabeticType = diabeticValue,
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
                                      headerText:
                                          'askHypertensivePatient'.trParams({
                                        'ask': 'askHim'.tr,
                                      }),
                                      fontSize: 18),
                                  const SizedBox(height: 5.0),
                                  DropdownList(
                                    dropdownController: controller
                                        .hypertensiveDropdownController,
                                    itemsList: controller.hypertensiveItems,
                                    onChanged: (bloodValue) => controller
                                        .hypertensivePatient = bloodValue,
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
                                      headerText: 'askHeartPatient'.trParams({
                                        'ask': 'askHim'.tr,
                                      }),
                                      fontSize: 18),
                                  const SizedBox(height: 5.0),
                                  DropdownList(
                                    dropdownController: controller
                                        .heartPatientDropdownController,
                                    itemsList: controller.heartPatientItems,
                                    onChanged: (heartPatientValue) => controller
                                        .heartPatient = heartPatientValue,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Obx(
                              () => RegularCard(
                                highlightRed: false,
                                child: SingleChildScrollView(
                                  child: controller.diseasesList.isNotEmpty
                                      ? Column(
                                          children: [
                                            for (var diseaseItem
                                                in controller.diseasesList)
                                              MedicalHistoryItem(
                                                  diseaseItem: diseaseItem,
                                                  onDeletePressed: () {
                                                    controller.diseasesList
                                                        .remove(diseaseItem);
                                                    if (controller
                                                        .diseasesList.isEmpty) {
                                                      Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      50))
                                                          .whenComplete(
                                                        () => controller
                                                            .medicalHistoryScrollController
                                                            .animateTo(
                                                          controller
                                                              .medicalHistoryScrollController
                                                              .position
                                                              .maxScrollExtent,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      700),
                                                          curve: Curves.easeIn,
                                                        ),
                                                      );
                                                    }
                                                  })
                                          ],
                                        )
                                      : const NoMedicalHistory(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: RegularElevatedButton(
                                buttonText: 'addAllergiesOrDiseases'.tr,
                                onPressed: () async => await RegularBottomSheet
                                    .showRegularBottomSheet(
                                  AddDisease(controller: controller),
                                ),
                                enabled: true,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        )
                      : const SizedBox.shrink()),
                  Obx(
                    () => RegularCard(
                      highlightRed: controller.highlightPatientCondition.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader(
                              headerText: 'enterConditionInformation'.tr,
                              fontSize: 18),
                          const SizedBox(height: 5.0),
                          TextFormFieldMultiline(
                            labelText: 'conditionInformation'.tr,
                            hintText: 'enterConditionInformation'.tr,
                            textController:
                                controller.patientConditionTextController,
                            textInputAction: TextInputAction.next,
                            inputFormatter:
                                LengthLimitingTextInputFormatter(150),
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
                      buttonText: 'continue'.tr,
                      onPressed: () async =>
                          await controller.confirmRequestInformation(),
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
