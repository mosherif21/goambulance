import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import '../../../general/common_widgets/text_form_field.dart';
import '../controllers/emergency_contacts_controller.dart';

class AddEmergencyContact extends StatelessWidget {
  const AddEmergencyContact({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final EmergencyContactsController controller;
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
            textController: controller.contactNameTextController,
            inputType: InputType.text,
            editable: true,
            textInputAction: TextInputAction.next,
            inputFormatter: LengthLimitingTextInputFormatter(50),
          ),
          const SizedBox(height: 10),
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
                controller.phoneNumber.value = phone.completeNumber,
          ),
          const SizedBox(height: 10.0),
          Obx(
            () => RegularElevatedButton(
              buttonText: 'add'.tr,
              onPressed: () => controller.addContact(),
              enabled: controller.contactName.value.isNotEmpty &&
                      controller.phoneNumber.value.isNotEmpty
                  ? true
                  : false,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
