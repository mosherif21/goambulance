import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:shimmer/shimmer.dart';

import '../../../general/general_functions.dart';

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
    final authRepo = AuthenticationRepository.instance;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SizedBox(
          height: screenHeight,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => authRepo.drawerProfileImageUrl.value.isURL
                          ? CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.grey.shade500,
                              backgroundImage: NetworkImage(
                                  authRepo.drawerProfileImageUrl.value),
                            )
                          : Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: Obx(
                        () => AutoSizeText(
                          authRepo.drawerAccountName.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          minFontSize: 22,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return MenuItemWidget(
                        key: Key(index.toString()),
                        item: mainMenu[index],
                        callback: callback,
                        widthBox: const SizedBox(width: 16.0),
                      );
                    },
                    itemCount: mainMenu.length,
                    shrinkWrap: true,
                  ),
                ),
                const SizedBox(height: 20),
              ],
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
        splashFactory: InkSparkle.splashFactory,
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
              child: AutoSizeText(
                item!.title,
                style: style,
                maxLines: 1,
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
