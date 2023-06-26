import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAds extends StatelessWidget {
  const LoadingAds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            for (int i = 0; i < 2; i++)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 150, width: 150, color: Colors.white),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
