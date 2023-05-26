import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../general/general_functions.dart';
import '../components/requests_history/components/request_history_item.dart';

class PreviousRequestsPage extends StatelessWidget {
  const PreviousRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          'recentRequests'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        scrolledUnderElevation: 5,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index != 16
                    ? RequestHistoryItem(
                        onPressed: () {},
                        hospitalName: 'Royal Hospital',
                        dateTime: 'Apr 17 2023 1:54 PM',
                        status: 'Pending',
                      )
                    : SizedBox(height: screenHeight * 0.07);
              },
              itemCount: 17,
              shrinkWrap: true,
            ),
          ),
        ),
      ),
    );
  }
}
