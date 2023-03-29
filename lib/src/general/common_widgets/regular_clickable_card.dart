import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RegularClickableCard extends StatelessWidget {
  const RegularClickableCard(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.subTitle,
      required this.icon,
      required this.iconColor,
      required this.imgPath})
      : super(key: key);
  final Function onPressed;
  final String imgPath;
  final String title;
  final String subTitle;
  final IconData icon;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(imgPath),
                height: 35.0,
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                  if (subTitle.isNotEmpty)
                    Text(
                      subTitle,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                ],
              ),
              const Spacer(),
              Icon(
                icon,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
