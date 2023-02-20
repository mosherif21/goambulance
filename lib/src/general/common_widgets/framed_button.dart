import 'package:flutter/material.dart';

class FramedIconButton extends StatelessWidget {
  const FramedIconButton({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.iconData,
    required this.onPressed,
    required this.height,
  }) : super(key: key);
  final String title;
  final String subTitle;
  final IconData iconData;
  final Function onPressed;
  final double height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        height: height,
        width: double.infinity,
        padding: EdgeInsets.all(height * 0.1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              size: height * 0.6,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  subTitle,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
