import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAds extends StatelessWidget {
  const LoadingAds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9, keepPage: true),
        itemCount: 3,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
