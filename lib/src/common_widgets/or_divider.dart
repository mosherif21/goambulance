import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    Key? key,
    required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(screenHeight * 0.02),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Divider(
              color: Colors.white,
              height: 8.0,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            'alternateLoginLabel'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenHeight * 0.02,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          const Expanded(
            child: Divider(
              color: Colors.white,
              height: 8.0,
            ),
          )
        ],
      ),
    );
  }
}
