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
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          splashFactory: InkSparkle.splashFactory,
          onTap: () => onPressed(),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(imgPath),
                  height: 35,
                  width: 45,
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
                      AutoSizeText(
                        subTitle,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                        maxLines: 1,
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
      ),
    );
  }
}
