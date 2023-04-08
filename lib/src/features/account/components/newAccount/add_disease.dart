import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/account/controllers/register_user_data_controller.dart';

import '../../../../constants/app_init_constants.dart';
import '../../../../constants/colors.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../general/common_widgets/text_form_field.dart';
import '../../../../general/common_widgets/text_form_field_multiline.dart';

class AddDisease extends StatelessWidget {
  const AddDisease({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final RegisterUserDataController controller;
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
            textController: controller.diseaseNameController,
            inputType: InputType.text,
            editable: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          TextFormFieldMultiline(
            labelText: 'medicineName'.tr,
            hintText: 'enterMedicineName'.tr,
            textController: controller.medicinesController,
            textInputAction: TextInputAction.done,
            // onSubmitted: () {
            //   Get.back();
            // },
          ),
          const SizedBox(height: 10.0),
          RegularElevatedButton(
            buttonText: 'add'.tr,
            onPressed: () {
              if (controller.diseaseNameController.text.trim().isNotEmpty) {
                final diseaseName =
                    controller.diseaseNameController.text.trim();
                final diseaseMedicines =
                    controller.medicinesController.text.trim();
                controller.diseasesList.add(DiseaseItem(
                    diseaseName: diseaseName,
                    diseaseMedicines: diseaseMedicines));
                controller.diseaseNameController.clear();
                controller.medicinesController.clear();
                Get.back();
              }
            },
            enabled: true,
            color: kDefaultColor,
          ),
        ],
      ),
    );
  }
}
