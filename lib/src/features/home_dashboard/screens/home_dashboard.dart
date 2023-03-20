import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: homeScreenController
                          .zoomDrawerController.stateNotifier!,
                      builder: (BuildContext context, DrawerState drawerState,
                          Widget? child) {
                        return Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  homeScreenController.toggleDrawer();
                                },
                                icon: Icon(
                                  homeScreenController
                                          .isDrawerOpeningOrOpen(drawerState)
                                      ? Icons.close
                                      : Icons.menu_outlined,
                                  size: 30,
                                )),
                            const Spacer(),
                            badges.Badge(
                              onTap: () {},
                              badgeContent: const Text('3'),
                              child: const Icon(
                                Icons.notifications,
                                size: 30,
                              ),
                            ),
                          ],
                        );
                      }),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'firstAidTips'.tr,
                          style: const TextStyle(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: Text('viewAll'.tr))
                    ],
                  ),
                  CarouselSlider(
                      items: homeScreenController.imageSliders,
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                      )),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'services'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ]),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 0, 10),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              foregroundColor:
                                  Colors.greenAccent, // <-- Splash color
                            ),
                            child: Image.asset(
                              'assets/images/ambulance.png',
                              fit: BoxFit.contain,
                              width: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text('normalRequest'.tr),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 50, 10),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              foregroundColor:
                                  Colors.greenAccent, // <-- Splash color
                            ),
                            child: Image.asset(
                              'assets/images/sos.png',
                              fit: BoxFit.contain,
                              width: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text('sosRequest'.tr),
                          ),
                        ],
                      ),
                    )
                  ]),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'recentRequests'.tr,
                        style: const TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Text('View All'))
                  ]),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
