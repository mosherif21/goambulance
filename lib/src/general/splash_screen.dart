import 'package:flutter_native_splash/flutter_native_splash.dart';

bool splashRemoved = false;

void removeSplashScreen() {
  if (!splashRemoved) {
    FlutterNativeSplash.remove();
    splashRemoved = true;
  }
}
