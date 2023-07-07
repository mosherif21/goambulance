import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/general_functions.dart';

import '../../../../../general/common_widgets/framed_button.dart';

class NavigationSelect extends StatelessWidget {
  const NavigationSelect({
    Key? key,
    required this.headerText,
    required this.onInAppNavigationPress,
    required this.onGoogleMapsNavigationPress,
  }) : super(key: key);
  final String headerText;
  final Function onInAppNavigationPress;
  final Function onGoogleMapsNavigationPress;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(
            headerText,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black87),
            maxLines: 2,
          ),
          const SizedBox(height: 15.0),
          FramedIconButton(
            height: screenHeight * 0.11,
            title: 'inAppNavigation'.tr,
            subTitle: '',
            iconData: Icons.app_shortcut,
            onPressed: () => onInAppNavigationPress(),
          ),
          const SizedBox(height: 10.0),
          FramedIconButton(
            height: screenHeight * 0.11,
            title: 'googleMapsNavigation'.tr,
            subTitle: '',
            iconData: Icons.map,
            onPressed: () => onGoogleMapsNavigationPress(),
          ),
        ],
      ),
    );
  }
}
