import 'package:flutter/material.dart';

class FirstAidTipsPage extends StatelessWidget {
  const FirstAidTipsPage({Key? key, required this.imgPath}) : super(key: key);
  final String imgPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imgPath,
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
            const Text(
                'kalam kteeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeer',
                textAlign: TextAlign.center)
          ],
        ),
      ),
    ));
  }
}
