import 'package:flutter/material.dart';

import '../../../general/common_widgets/back_button.dart';

class FirstAidTipsDetailsPage extends StatelessWidget {
  const FirstAidTipsDetailsPage({Key? key, required this.imgPath})
      : super(key: key);
  final String imgPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        elevation: 0,
        scrolledUnderElevation: 5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Image(
              image: AssetImage(
                imgPath,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
