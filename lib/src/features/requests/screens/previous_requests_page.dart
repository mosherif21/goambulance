import 'package:flutter/material.dart';

class PreviousRequestsPage extends StatelessWidget {
  const PreviousRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: Center(
          child: Text('requests'),
        ),
      ),
    );
  }
}
