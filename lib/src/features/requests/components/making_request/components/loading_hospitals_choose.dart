import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../general/general_functions.dart';

class LoadingHospitalCard extends StatelessWidget {
  const LoadingHospitalCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LineIcon.hospital(
              size: screenHeight * 0.07,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 15,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
