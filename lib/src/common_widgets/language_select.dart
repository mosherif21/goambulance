import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/assets_strings.dart';

class LanguageSelect extends StatelessWidget {
  const LanguageSelect(
      {Key? key,
      required this.onEnglishLanguagePress,
      required this.onArabicLanguagePress})
      : super(key: key);
  final Function onEnglishLanguagePress;
  final Function onArabicLanguagePress;
  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
        fontSize: 25.0, fontWeight: FontWeight.w600, color: Colors.black54);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'chooseLanguage'.tr,
          style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: Colors.black87),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => onEnglishLanguagePress(),
            icon: const Image(
              image: AssetImage(kUkFlagImage),
              height: 60.0,
            ),
            label: Text(
              'english'.tr,
              style: textStyle,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => onArabicLanguagePress(),
            icon: const Image(
              image: AssetImage(kSAFlagImage),
              height: 60.0,
            ),
            label: Text(
              'arabic'.tr,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
