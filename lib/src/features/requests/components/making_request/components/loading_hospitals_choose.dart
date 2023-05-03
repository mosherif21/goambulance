import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../general/general_functions.dart';

class LoadingHospitalChoose extends StatelessWidget {
  const LoadingHospitalChoose({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LineIcon.hospital(
                      size: screenHeight * 0.07,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 15, width: 100, color: Colors.white),
                        const SizedBox(height: 5),
                        Container(height: 10, width: 50, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
