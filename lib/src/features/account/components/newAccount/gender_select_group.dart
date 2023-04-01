import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../controllers/register_user_data_controller.dart';

class GenderRadioGroup extends StatelessWidget {
  const GenderRadioGroup(
      {Key? key, required this.defaultGender, required this.onGenderSelected})
      : super(key: key);
  final Gender? defaultGender;
  final Function onGenderSelected;
  @override
  Widget build(BuildContext context) {
    return CustomRadioButton(
      buttonTextStyle: const ButtonTextStyle(
        selectedColor: Colors.white,
        unSelectedColor: Colors.black87,
        textStyle: TextStyle(
          fontSize: 16,
        ),
      ),
      unSelectedColor: Theme.of(context).canvasColor,
      buttonLables: ['male'.tr, 'female'.tr],
      spacing: 10,
      elevation: 0,
      enableShape: true,
      defaultSelected: defaultGender,
      horizontal: false,
      enableButtonWrap: false,
      width: 110,
      absoluteZeroSpacing: false,
      padding: 15,
      selectedColor: kDefaultColor,
      buttonValues: const [
        Gender.male,
        Gender.female,
      ],
      radioButtonValue: (gender) => onGenderSelected(gender),
    );
  }
}
