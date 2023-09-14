import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/enums.dart';
import 'package:goambulance/src/general/validation_functions.dart';

import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/custom_rolling_switch.dart';
import '../../../../general/common_widgets/dropdown_list.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../general/common_widgets/regular_card.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../../general/common_widgets/text_form_field.dart';
import '../../../../general/common_widgets/text_form_field_multiline.dart';
import '../../../../general/common_widgets/text_header.dart';
import '../../../account/components/edit_account/edit_disease.dart';
import '../../../account/components/new_account/add_disease.dart';
import '../../../account/components/new_account/medical_history_item.dart';
import '../../../account/components/new_account/no_medical_history.dart';
import '../../controllers/making_request_information_controller.dart';

class NormalRequestScreen extends StatelessWidget {
  const NormalRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MakingRequestInformationController());
    return Form(
      key: controller.formKey,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const RegularBackButton(padding: 0),
          title: AutoSizeText(
            'normalRequest'.tr,
            maxLines: 1,
          ),
          titleTextStyle: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    RegularCard(
                      highlightRed: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader(
                            headerText: 'requestFor'.tr,
                            fontSize: 18,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5.0),
                          DropdownList(
                            items: [
                              'forMe'.tr,
                              'someoneElse'.tr,
                            ],
                            dropDownController:
                                controller.requestTypeDropdownController,
                            hintText: 'selectValue'.tr,
                          ),
                        ],
                      ),
                    ),
                    Obx(() => controller.userRequest.value
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              RegularCard(
                                highlightRed: false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextHeader(
                                      headerText: 'enterHisAge'.tr,
                                      fontSize: 18,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5.0),
                                    TextFormFieldRegular(
                                      labelText: 'age'.tr,
                                      hintText: 'enterHisAgeHint'.tr,
                                      textController:
                                          controller.patientAgeController,
                                      textInputAction: TextInputAction.next,
                                      inputFormatter:
                                          LengthLimitingTextInputFormatter(20),
                                      prefixIconData:
                                          Icons.access_time_outlined,
                                      inputType: InputType.numbers,
                                      editable: true,
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
                                      headerText: 'chooseHisBloodType'.tr,
                                      fontSize: 18,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5.0),
                                    DropdownList(
                                      items: [
                                        'don\'tKnow'.tr,
                                        'A+',
                                        'O+',
                                        'B+',
                                        'AB+',
                                        'A-',
                                        'O-',
                                        'B-',
                                        'AB-',
                                      ],
                                      dropDownController: controller
                                          .bloodTypeDropdownController,
                                      hintText: 'don\'tKnow'.tr,
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
                                      fontSize: 18,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5.0),
                                    DropdownList(
                                      items: [
                                        'don\'tKnow'.tr,
                                        'no'.tr,
                                        'Type 1',
                                        'Type 2',
                                      ],
                                      dropDownController:
                                          controller.diabetesDropdownController,
                                      hintText: 'don\'tKnow'.tr,
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
                                      fontSize: 18,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5.0),
                                    DropdownList(
                                      items: [
                                        'don\'tKnow'.tr,
                                        'yes'.tr,
                                        'no'.tr,
                                      ],
                                      dropDownController: controller
                                          .hypertensiveDropdownController,
                                      hintText: 'don\'tKnow'.tr,
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
                                      fontSize: 18,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5.0),
                                    DropdownList(
                                      items: [
                                        'don\'tKnow'.tr,
                                        'yes'.tr,
                                        'no'.tr,
                                      ],
                                      dropDownController: controller
                                          .heartPatientDropdownController,
                                      hintText: 'don\'tKnow'.tr,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => RegularCard(
                                  highlightRed: false,
                                  child: StretchingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    child: SingleChildScrollView(
                                      child: controller.diseasesList.isNotEmpty
                                          ? Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: AutoSizeText(
                                                    'addedDiseases'.tr,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                for (var diseaseItem
                                                    in controller.diseasesList)
                                                  MedicalHistoryItem(
                                                    diseaseItem: diseaseItem,
                                                    onDeletePressed: () =>
                                                        controller.diseasesList
                                                            .remove(
                                                                diseaseItem),
                                                    onEditPressed: () {
                                                      RegularBottomSheet
                                                          .showRegularBottomSheet(
                                                        EditDisease(
                                                          controller:
                                                              controller,
                                                          diseaseItem:
                                                              diseaseItem,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0,
                                                          right: 15.0),
                                                  child: RoundedElevatedButton(
                                                    buttonText:
                                                        'addAllergiesOrDiseases'
                                                            .tr,
                                                    onPressed: () =>
                                                        RegularBottomSheet
                                                            .showRegularBottomSheet(
                                                      AddDisease(
                                                          controller:
                                                              controller),
                                                    ),
                                                    enabled: true,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : NoMedicalHistory(
                                              controller: controller),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    RegularCard(
                      highlightRed: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader(
                            headerText: 'enterConditionInformation'.tr,
                            fontSize: 18,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5.0),
                          TextFormFieldMultiline(
                            labelText: 'conditionInformation'.tr,
                            hintText: 'enterConditionInformation'.tr,
                            textController:
                                controller.patientConditionTextController,
                            textInputAction: TextInputAction.next,
                            inputFormatter:
                                LengthLimitingTextInputFormatter(150),
                            validationFunction: validateTextOnly,
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
                            headerText: 'enterAdditionalInformation'.tr,
                            fontSize: 18,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5.0),
                          TextFormFieldMultiline(
                            labelText: 'additionalInformation'.tr,
                            hintText: 'enterAdditionalInformation'.tr,
                            textController:
                                controller.additionalInformationTextController,
                            textInputAction: TextInputAction.done,
                            inputFormatter:
                                LengthLimitingTextInputFormatter(150),
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
                            headerText: 'sendSosSms'.tr,
                            fontSize: 18,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              const Spacer(),
                              CustomRollingSwitch(
                                keyInternal: controller.sendSosPrimaryKey,
                                onText: 'yes'.tr,
                                offText: 'no'.tr,
                                onIcon: Icons.check,
                                offIcon: Icons.close,
                                onSwitched: controller.onSendSosSwitched,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: RegularElevatedButton(
                        buttonText: 'continue'.tr,
                        onPressed: () => controller.confirmRequestInformation(),
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
      ),
    );
  }
}
