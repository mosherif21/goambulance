import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';

import '../../../general/common_functions.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  'assets/images/accident.png',
  'assets/images/burn.png',
  'assets/images/electrocute.png',
  'assets/images/fracture.png',
  'assets/images/nose.png',
  'assets/images/wound.png'
];
final List<Widget> imageSliders = imgList
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.asset(item, fit: BoxFit.contain, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        'No. ${imgList.indexOf(item)} image',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ))
    .toList();

class HomeDashBoard extends StatelessWidget {
  const HomeDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenController = HomeScreenController.instance;
    return Scaffold(
        body: Container(
      /*
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Colors.blueGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),*/
      child: Center(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          homeScreenController.toggleDrawer();
                        },
                        icon: Image.asset('assets/images/menu (1).png')),
                    const Spacer(),
                    badges.Badge(
                      onTap: () {},
                      badgeContent: const Text('3'),
                      child: Image.asset(
                        'assets/images/notification-bell.png',
                        fit: BoxFit.contain,
                        width: 40,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'First Aid Tips',
                        style: TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Text('View All'))
                  ],
                ),
                CarouselSlider(
                    items: imageSliders,
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    )),
                Row(children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      'Order an Ambulance',
                      style: TextStyle(
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
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text('Normal Request'),
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
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text('SOS Request'),
                        ),
                      ],
                    ),
                  )
                ]),
                Row(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      'Recent Trips',
                      style: TextStyle(
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

            /*RegularElevatedButton(
              buttonText: 'show drawer',
              onPressed: () {
                homeScreenController.toggleDrawer();
              },
              enabled: true,
            ),
            RegularElevatedButton(
              buttonText: 'logout'.tr,
              onPressed: () async => await logout(),
              enabled: true,
            ),*/
          ],
        ),
      ),
    ));
  }
}
