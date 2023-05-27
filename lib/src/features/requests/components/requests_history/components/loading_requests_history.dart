import 'package:flutter/material.dart';

import '../../../../../general/general_functions.dart';
import '../../making_request/components/loading_hospitals_choose.dart';

class LoadingRequestsHistory extends StatelessWidget {
  const LoadingRequestsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return ListView.builder(
      itemBuilder: (context, index) => index != 7
          ? const LoadingHospitalCard()
          : SizedBox(height: screenHeight * 0.08),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 8,
    );
  }
}
