import 'package:flutter/material.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';

import '../../../general/common_functions.dart';

class DrawerPage extends StatelessWidget {
  final List<MenuClass> mainMenu;
  final void Function(int)? callback;
  final int? current;

  const DrawerPage(
    this.mainMenu, {
    super.key,
    this.callback,
    this.current,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 24.0,
                          left: 24.0,
                          right: 24.0,
                        ),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 36.0,
                          left: 24.0,
                          right: 24.0,
                        ),
                        child: Text(
                          'Mohamed Sherif',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ...mainMenu
                          .map(
                            (item) => MenuItemWidget(
                              key: Key(item.index.toString()),
                              item: item,
                              callback: callback,
                              widthBox: const SizedBox(width: 16.0),
                            ),
                          )
                          .toList()
                    ],
                  ),
                  //SizedBox(height: screenHeight * 0.04),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  //   child: OutlinedButton(
                  //     style: OutlinedButton.styleFrom(
                  //       side: const BorderSide(
                  //           color: Colors.black, width: 2.0),
                  //       foregroundColor: const Color(0x44000000),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16.0),
                  //       ),
                  //       textStyle: const TextStyle(color: Colors.black),
                  //     ),
                  //     onPressed: () async => await logout(),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text(
                  //         'logout'.tr,
                  //         style: const TextStyle(
                  //             fontSize: 18, color: Colors.black),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuClass? item;
  final Widget? widthBox;
  final void Function(int)? callback;

  const MenuItemWidget({
    Key? key,
    this.item,
    this.widthBox,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const androidStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    const iosStyle = TextStyle(color: Colors.black);
    final style = AppInit.isWeb
        ? androidStyle
        : AppInit.isAndroid
            ? androidStyle
            : iosStyle;
    return TextButton(
      onPressed: () => callback!(item!.index),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0x44000000),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppInit.isWeb ? 10 : 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              item!.icon,
              color: Colors.black,
              size: 30,
            ),
            widthBox!,
            Expanded(
              child: Text(
                item!.title,
                style: style,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MenuClass {
  final String title;
  final IconData icon;
  final int index;

  const MenuClass(this.title, this.icon, this.index);
}
