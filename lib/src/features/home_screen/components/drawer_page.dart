import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/general/common_functions.dart';

import '../controllers/home_screen_controller.dart';

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
    final homeScreenController = HomeScreenController.instance;
    final screenHeight = getScreenHeight(context);
    const androidStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    const iosStyle = TextStyle(color: Colors.white);
    final style = kIsWeb
        ? androidStyle
        : AppInit.isAndroid
            ? androidStyle
            : iosStyle;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Colors.indigo,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.1, left: 5.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
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
                          'name',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => Column(
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
                                style: style,
                                selected:
                                    homeScreenController.currentPage.value ==
                                        item.index,
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () async => await logout(),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'logout',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Spacer(),
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
  final TextStyle? style;
  final void Function(int)? callback;
  final bool? selected;

  const MenuItemWidget({
    Key? key,
    this.item,
    this.widthBox,
    this.style,
    this.callback,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => callback!(item!.index),
      style: TextButton.styleFrom(
        foregroundColor: selected! ? const Color(0x44000000) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item!.icon,
            color: Colors.white,
            size: 24,
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
    );
  }
}

class MenuClass {
  final String title;
  final IconData icon;
  final int index;

  const MenuClass(this.title, this.icon, this.index);
}
