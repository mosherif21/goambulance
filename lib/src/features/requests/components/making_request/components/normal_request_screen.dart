import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/common_widgets/dropdown_list.dart';
import '../../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../../general/common_widgets/regular_card.dart';
import '../../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../../../general/common_widgets/text_form_field_multiline.dart';
import '../../../../../general/common_widgets/text_header.dart';
import '../../../../account/components/newAccount/add_disease.dart';
import '../../../../account/components/newAccount/medical_history_item.dart';
import '../../../../account/components/newAccount/no_medical_history.dart';
import '../../../controllers/making_request_information_controller.dart';

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
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
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
                  Obx(
                    () => RegularCard(
                      highlightRed: controller.highlightRequest.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader(headerText: 'requestFor'.tr, fontSize: 18),
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
                                      headerText: 'chooseHisBloodType'.tr,
                                      fontSize: 18),
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
                                    dropDownController:
                                        controller.bloodTypeDropdownController,
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
                                      fontSize: 18),
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
                                      fontSize: 18),
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
                                      fontSize: 18),
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
                                                  onDeletePressed: () =>
                                                      controller.diseasesList
                                                          .remove(diseaseItem),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0, right: 15.0),
                                                child: RoundedElevatedButton(
                                                  buttonText:
                                                      'addAllergiesOrDiseases'
                                                          .tr,
                                                  onPressed: () =>
                                                      RegularBottomSheet
                                                          .showRegularBottomSheet(
                                                    AddDisease(
                                                        controller: controller),
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
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(
                            headerText: 'enterBackupPhoneNo'.tr, fontSize: 18),
                        const SizedBox(height: 5.0),
                        IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: 'phoneLabel'.tr,
                            hintText: 'phoneFieldLabel'.tr,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'EG',
                          countries: const ['EG'],
                          pickerDialogStyle: PickerDialogStyle(
                            searchFieldInputDecoration:
                                InputDecoration(hintText: 'searchCountry'.tr),
                          ),
                          onChanged: (phone) =>
                              controller.backupPhoneNo = phone.completeNumber,
                        ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
