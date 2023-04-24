import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

class HospitalChooseCard extends StatelessWidget {
  const HospitalChooseCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey.shade400,
          ),
        ],
      ),
      child: Row(
        children: [
          LineIcon.hospital(
            size: 50,
          )
        ],
      ),
    );
  }
}
