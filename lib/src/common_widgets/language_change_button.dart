import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/common_widgets/regular_bottom_sheet.dart';

import '../../localization/language/language_functions.dart';
import '../constants/app_init_constants.dart';
import 'language_select.dart';

class ButtonLanguageSelect extends StatelessWidget {
  const ButtonLanguageSelect({Key? key, required this.screenHeight})
      : super(key: key);
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AppInit.currentDeviceLanguage == Language.english
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: SizedBox(
        width: screenHeight * 0.1,
        child: TextButton(
          onPressed: () async {
            await RegularBottomSheet.showRegularBottomSheet(
              LanguageSelect(
                onEnglishLanguagePress: () async {
                  await setLocaleLanguageBack('en');
                },
                onArabicLanguagePress: () async {
                  await setLocaleLanguageBack('ar');
                },
              ),
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.language_rounded,
                color: Colors.black54,
              ),
              Text(
                'lang'.tr,
                style: TextStyle(
                    fontFamily: 'Bruno Ace',
                    fontSize: screenHeight * 0.02,
                    color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
