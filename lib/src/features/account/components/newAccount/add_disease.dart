import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../constants/enums.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/common_widgets/text_form_field.dart';
import '../../../../general/common_widgets/text_form_field_multiline.dart';

class AddDisease extends StatelessWidget {
  const AddDisease({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final dynamic controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'diseaseInfo'.tr,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black87),
            maxLines: 2,
          ),
          const SizedBox(height: 10.0),
          TextFormFieldRegular(
            labelText: 'diseaseName'.tr,
            hintText: 'enterDiseaseName'.tr,
            prefixIconData: Icons.coronavirus_outlined,
            textController: controller.diseaseNameTextController,
            inputType: InputType.text,
            editable: true,
            textInputAction: TextInputAction.next,
            inputFormatter: LengthLimitingTextInputFormatter(50),
          ),
          const SizedBox(height: 10),
          TextFormFieldMultiline(
            labelText: 'medicineName'.tr,
            hintText: 'enterMedicineName'.tr,
            textController: controller.medicinesTextController,
            textInputAction: TextInputAction.done,
            inputFormatter: LengthLimitingTextInputFormatter(100),
          ),
          const SizedBox(height: 10.0),
          Obx(
            () => RegularElevatedButton(
              buttonText: 'add'.tr,
              onPressed: () => controller.addDiseaseItem(),
              enabled: controller.diseaseName.value.isNotEmpty ? true : false,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
