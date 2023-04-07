import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class RoundedRadioButtonGroup extends StatelessWidget {
  const RoundedRadioButtonGroup({
    Key? key,
    required this.buttonLabels,
    required this.buttonValues,
    required this.radioButtonOnPress,
    required this.radioGroupKey,
  }) : super(key: key);
  final List<String> buttonLabels;
  final List buttonValues;
  final Function radioButtonOnPress;
  final Key radioGroupKey;
  @override
  Widget build(BuildContext context) {
    return CustomRadioButton(
        key: radioGroupKey,
        buttonTextStyle: const ButtonTextStyle(
          selectedColor: Colors.white,
          unSelectedColor: Colors.black87,
          textStyle: TextStyle(
            fontSize: 16,
          ),
        ),
        unSelectedColor: Theme.of(context).canvasColor,
        buttonLables: buttonLabels,
        spacing: 10,
        elevation: 0,
        enableShape: true,
        horizontal: false,
        enableButtonWrap: false,
        width: 110,
        absoluteZeroSpacing: false,
        padding: 15,
        selectedColor: kDefaultColor,
        buttonValues: buttonValues,
        radioButtonValue: (value) => radioButtonOnPress(value));
  }
}
