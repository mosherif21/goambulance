import 'package:flutter/material.dart';

import '../../../general/common_widgets/back_button.dart';

class FirstAidTipsDetailsPage extends StatelessWidget {
  const FirstAidTipsDetailsPage({Key? key, required this.imgPath})
      : super(key: key);
  final String imgPath;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RegularBackButton(),
              Image(
                image: AssetImage(
                  imgPath,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
