import 'package:flutter/material.dart';

import '../../../general/common_widgets/back_button.dart';

class FirstAidTipsDetailsPage extends StatelessWidget {
  const FirstAidTipsDetailsPage({Key? key, required this.imgPath})
      : super(key: key);
  final String imgPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RegularBackButton(padding: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Image(
                  image: AssetImage(
                    imgPath,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
