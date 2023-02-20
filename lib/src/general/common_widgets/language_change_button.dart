import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/regular_bottom_sheet.dart';

import '../../../localization/language/language_functions.dart';
import '../../constants/app_init_constants.dart';
import 'language_select.dart';

class ButtonLanguageSelect extends StatelessWidget {
  const ButtonLanguageSelect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AppInit.currentDeviceLanguage == Language.english
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: SizedBox(
        width: AppInit.currentDeviceLanguage == Language.english ? 75.0 : 85.0,
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
                size: 24.0,
              ),
              Text(
                'lang'.tr,
                style: const TextStyle(
                    fontFamily: 'Bruno Ace',
                    fontSize: 17.0,
                    color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
