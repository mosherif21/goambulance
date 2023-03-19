import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_init_constants.dart';
import '../common_functions.dart';

class ButtonLanguageSelect extends StatelessWidget {
  const ButtonLanguageSelect({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AppInit.currentDeviceLanguage == Language.english
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: SizedBox(
        width: AppInit.currentDeviceLanguage == Language.english ? 75.0 : 85.0,
        child: TextButton(
          style: TextButton.styleFrom(foregroundColor: const Color(0x44000000)),
          onPressed: () async => await displayChangeLang(),
          child: Row(
            children: [
              Icon(
                Icons.language_rounded,
                color: color,
                size: 24.0,
              ),
              Text(
                'lang'.tr,
                style: TextStyle(
                    fontFamily: 'Bruno Ace', fontSize: 17.0, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
