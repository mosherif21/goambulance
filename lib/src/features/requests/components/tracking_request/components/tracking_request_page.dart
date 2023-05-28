import 'package:flutter/material.dart';
import 'package:goambulance/src/features/requests/components/requests_history/models.dart';

class TrackingRequestPage extends StatelessWidget {
  const TrackingRequestPage({Key? key, required this.requestModel})
      : super(key: key);
  final RequestHistoryModel requestModel;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
