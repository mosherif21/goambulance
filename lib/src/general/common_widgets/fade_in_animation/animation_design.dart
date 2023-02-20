import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'fade_in_animation_controller.dart';
import 'fade_in_animation_model.dart';

class FadeInAnimationTemp extends StatelessWidget {
  FadeInAnimationTemp(
      {Key? key,
      required this.duration,
      this.animationPosition,
      required this.child})
      : super(key: key);
  final controller = Get.put(FadeInAnimationController());
  final int duration;
  final AnimationPositionModel? animationPosition;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: Duration(milliseconds: duration),
        top: controller.animate.value
            ? animationPosition!.topAfter
            : animationPosition!.topBefore,
        bottom: controller.animate.value
            ? animationPosition!.bottomAfter
            : animationPosition!.bottomBefore,
        left: controller.animate.value
            ? animationPosition!.leftAfter
            : animationPosition!.leftBefore,
        right: controller.animate.value
            ? animationPosition!.rightAfter
            : animationPosition!.rightBefore,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: duration),
          opacity: controller.animate.value ? 1 : 0,
          child: child,
        ),
      ),
    );
  }
}
