import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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
    const TextStyle textStyle = TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.w600, color: Colors.black);
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.black54),
              onPressed: () => onChoosePhotoPress(),
              icon: const Icon(
                FontAwesomeIcons.photoVideo,
                color: Colors.black,
              ),
              label: Text(
                'pickGallery'.tr,
                style: textStyle,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.black54),
              onPressed: () => onCapturePhotoPress(),
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              label: Text(
                'capturePhoto'.tr,
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
