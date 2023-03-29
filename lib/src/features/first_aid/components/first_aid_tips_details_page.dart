import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Get.back(),
                ),
              ),
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
