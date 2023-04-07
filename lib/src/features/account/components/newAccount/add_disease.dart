import 'package:flutter/material.dart';

class AddDiseaseSelect extends StatelessWidget {
  const AddDiseaseSelect({
    Key? key,
    required this.headerText,
    required this.onAddDiseaseSelect,
    required this.onAddAllergySelect,
  }) : super(key: key);
  final String headerText;
  final Function onAddDiseaseSelect;
  final Function onAddAllergySelect;
  @override
  Widget build(BuildContext context) {
    //final screenHeight = getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}
