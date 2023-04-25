import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

class LoadingHospitalChoose extends StatelessWidget {
  const LoadingHospitalChoose({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          LineIcon.hospital(
            size: 60,
          )
        ],
      ),
    );
  }
}
