import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/assets_strings.dart';

class MyLocationButton extends StatelessWidget {
  const MyLocationButton({Key? key, required this.onLocationButtonPress})
      : super(key: key);
  final Function onLocationButtonPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Material(
        elevation: 5,
        shape: const CircleBorder(),
        color: Colors.white,
        child: InkWell(
          customBorder: const CircleBorder(),
          splashFactory: InkSparkle.splashFactory,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              kMyLocation,
              height: 30,
            ),
          ),
          onTap: () => onLocationButtonPress(),
        ),
      ),
    );
  }
}
