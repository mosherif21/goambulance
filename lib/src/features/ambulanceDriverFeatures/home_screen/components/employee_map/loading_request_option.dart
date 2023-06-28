import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingRequestInfo extends StatelessWidget {
  const LoadingRequestInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (_, __) {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      height: 30,
                      width: 30),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 9,
                    child: Container(color: Colors.white, height: 30),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    height: 30,
                    width: 30,
                  ),
                ],
              ),
            );
          },
          shrinkWrap: true,
          padding: EdgeInsets.zero),
    );
  }
}
