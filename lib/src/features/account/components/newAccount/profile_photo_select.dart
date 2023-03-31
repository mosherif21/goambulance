import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_functions.dart';

import '../../../../general/common_widgets/framed_button.dart';

class ProfilePhotoSelect extends StatelessWidget {
  const ProfilePhotoSelect({
    Key? key,
    required this.onCapturePhotoPress,
    required this.onChoosePhotoPress,
  }) : super(key: key);
  final Function onCapturePhotoPress;
  final Function onChoosePhotoPress;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'choosePicMethod'.tr,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black87),
          ),
          const SizedBox(height: 10.0),
          FramedIconButton(
            height: screenHeight * 0.11,
            title: 'pick'.tr,
            subTitle: 'pickGallery'.tr,
            iconData: Icons.photo,
            onPressed: () => onChoosePhotoPress(),
          ),
          const SizedBox(height: 10.0),
          FramedIconButton(
            height: screenHeight * 0.11,
            title: 'capture'.tr,
            subTitle: 'capturePhoto'.tr,
            iconData: Icons.camera_alt,
            onPressed: () => onCapturePhotoPress(),
          ),
        ],
      ),
    );
  }
}
