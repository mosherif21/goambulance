import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:goambulance/src/features/home_screen/components/page_structure.dart';
import 'package:provider/provider.dart';

import 'menu_page.dart';

class HomeScreenTest extends StatefulWidget {
  static List<MenuClass> mainMenu = const [
    MenuClass("payment", Icons.payment, 0),
    MenuClass("promos", Icons.card_giftcard, 1),
    MenuClass("notifications", Icons.notifications, 2),
    MenuClass("help", Icons.help, 3),
    MenuClass("about_us", Icons.info_outline, 4),
  ];

  const HomeScreenTest({super.key});

  @override
  HomeScreenTestState createState() => HomeScreenTestState();
}

class HomeScreenTestState extends State<HomeScreenTest> {
  final _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    const isRtl = false;
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: MenuScreen(
        HomeScreenTest.mainMenu,
        callback: _updatePage,
        current: 0,
      ),
      mainScreen: const MainScreen(),
      openCurve: Curves.fastOutSlowIn,
      showShadow: false,
      slideWidth: MediaQuery.of(context).size.width * (0.65),
      isRtl: isRtl,
      mainScreenTapClose: true,
      mainScreenOverlayColor: Colors.brown.withOpacity(0.5),
      borderRadius: 10,
      angle: 0.0,
      menuScreenWidth: double.infinity,
      moveMenuScreen: false,
      style: DrawerStyle.defaultStyle,
      drawerShadowsBackgroundColor: Colors.yellow,
      mainScreenAbsorbPointer: false,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  void _updatePage(int index) {
    context.read<MenuProvider>().updateCurrentPage(index);
    _drawerController.toggle?.call();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    const rtl = false;
    return ValueListenableBuilder<DrawerState>(
      valueListenable: ZoomDrawer.of(context)!.stateNotifier,
      builder: (context, state, child) {
        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        child: const PageStructure(),
        onPanUpdate: (details) {
          if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
            ZoomDrawer.of(context)?.toggle.call();
          }
        },
      ),
    );
  }
}

class MenuProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index == currentPage) return;
    _currentPage = index;
    notifyListeners();
  }
}
