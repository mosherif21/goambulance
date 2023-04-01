import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_functions.dart';

import '../../../../general/common_widgets/framed_button.dart';

class PhotoSelect extends StatelessWidget {
  const PhotoSelect({
    Key? key,
    required this.onCapturePhotoPress,
    this.onChoosePhotoPress,
    required this.headerText,
    required this.displayGalleryPick,
  }) : super(key: key);
  final String headerText;
  final Function onCapturePhotoPress;
  final Function? onChoosePhotoPress;
  final bool displayGalleryPick;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.all(30.0),
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
          if (displayGalleryPick) const SizedBox(height: 15.0),
          if (displayGalleryPick)
            FramedIconButton(
              height: screenHeight * 0.11,
              title: 'pickGallery'.tr,
              subTitle: '',
              iconData: Icons.photo,
              onPressed: () => onChoosePhotoPress!(),
            ),
          const SizedBox(height: 10.0),
          FramedIconButton(
            height: screenHeight * 0.11,
            title: 'capturePhoto'.tr,
            subTitle: '',
            iconData: Icons.camera_alt,
            onPressed: () => onCapturePhotoPress(),
          ),
        ],
      ),
    );
  }
}
