import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

class FirstAidTips extends StatelessWidget {
  const FirstAidTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/accident.png',
              fit: BoxFit.scaleDown,
              width: 200,
              height: 200,
            ),
            Row(
              children: const [
                Text(
                  'Wound First Aid Tips',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                )
              ],
            ),
            Text(
                'kalam kteeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeer',
                textAlign: TextAlign.center)
          ],
        ),
      ),
    ));
  }
}
