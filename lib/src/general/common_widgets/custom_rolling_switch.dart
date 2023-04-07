import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:rolling_switch/rolling_switch.dart';

class CustomRollingSwitch extends StatelessWidget {
  const CustomRollingSwitch(
      {Key? key,
      required this.onText,
      required this.offText,
      required this.onIcon,
      required this.offIcon,
      required this.onSwitched})
      : super(key: key);
  final String onText;
  final String offText;
  final IconData onIcon;
  final IconData offIcon;
  final Function onSwitched;
  @override
  Widget build(BuildContext context) {
    return RollingSwitch.icon(
      onChanged: (bool state) => onSwitched(state),
      rollingInfoRight: RollingIconInfo(
        icon: onIcon,
        backgroundColor: kDefaultColor,
        text: Text(
          onText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      rollingInfoLeft: RollingIconInfo(
        icon: offIcon,
        backgroundColor: Colors.grey,
        text: Text(
          offText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
