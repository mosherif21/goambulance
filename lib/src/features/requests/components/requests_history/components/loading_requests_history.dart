import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../general/general_functions.dart';

class LoadingRequestsHistory extends StatelessWidget {
  const LoadingRequestsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return ListView.builder(
      itemBuilder: (context, index) => index != 5
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: index == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 350,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      width: 150,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 50,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: LineIcon.hospital(size: 40),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: 150,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: 50,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
              ),
            )
          : SizedBox(height: screenHeight * 0.08),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 6,
    );
  }
}
