import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/text_form_field.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_init_constants.dart';
import '../constants/sizes.dart';

class SingleEntryScreen extends StatelessWidget {
  const SingleEntryScreen(
      {Key? key,
      required this.title,
      required this.lottieAssetAnim,
      required this.textFormTitle,
      required this.textFormHint,
      required this.buttonTitle,
      required this.prefixIconData,
      required this.onPressed,
      required this.inputType})
      : super(key: key);
  final String title;
  final String lottieAssetAnim;
  final String textFormTitle;
  final String textFormHint;
  final String buttonTitle;
  final IconData prefixIconData;
  final Function onPressed;
  final InputType inputType;
  @override
  Widget build(BuildContext context) {
    double? screenHeight = Get.context?.height;
    String textFieldString = '';
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPaddingSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAssetAnim,
              height: screenHeight! * 0.5,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormFieldRegular(
              labelText: textFormTitle,
              hintText: textFormHint,
              prefixIconData: prefixIconData,
              color: Colors.black,
              onTextChanged: (text) => textFieldString = text,
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                ),
                onPressed: () {
                  onPressed(textFieldString);
                },
                child: Text(
                  buttonTitle,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
