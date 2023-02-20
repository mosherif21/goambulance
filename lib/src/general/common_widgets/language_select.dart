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
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
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
              style: OutlinedButton.styleFrom(foregroundColor: Colors.black54),
              onPressed: () => onEnglishLanguagePress(),
              icon: Image.asset(
                kUkFlagImage,
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
              style: OutlinedButton.styleFrom(foregroundColor: Colors.black54),
              onPressed: () => onArabicLanguagePress(),
              icon: Image.asset(
                kSAFlagImage,
                height: 60.0,
              ),
              label: Text(
                'arabic'.tr,
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
