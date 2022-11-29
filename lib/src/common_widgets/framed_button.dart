import 'package:flutter/material.dart';

import '../constants/app_init_constants.dart';

class FramedIconButton extends StatelessWidget {
  const FramedIconButton(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.iconData,
      required this.onPressed})
      : super(key: key);
  final String title;
  final String subTitle;
  final IconData iconData;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            Icon(iconData, size: AppInit.notWebMobile ? 80.0 : 60.0),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  subTitle,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w100),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
