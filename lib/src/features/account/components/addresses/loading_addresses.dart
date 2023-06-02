import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAddresses extends StatelessWidget {
  const LoadingAddresses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 20, width: 100, color: Colors.white),
                    const SizedBox(height: 5),
                    Container(height: 15, width: 50, color: Colors.white),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
