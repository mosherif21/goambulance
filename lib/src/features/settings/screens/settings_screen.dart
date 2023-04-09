import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: StretchingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        child: Center(
          child: Text('Settings'),
        ),
      ),
    );
  }
}
