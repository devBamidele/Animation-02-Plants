import 'package:animation_02_plants/components/animated_exit_sliver_bar.dart';
import 'package:animation_02_plants/components/custom_sliver_list.dart';
import 'package:animation_02_plants/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../components/animated_blur_overlay.dart';
import '../components/bottom_nav_bar.dart';

class Page1 extends HookWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    /// Triggers zoom out and backdrop fade when bottom nav is active
    final overlayCtrl = useState<AnimationController?>(null);

    /// Controls the exit animation during page transitions
    final navCtrl = useState<AnimationController?>(null);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: AnimatedBuilder(
              animation: overlayCtrl.value ?? const AlwaysStoppedAnimation(0.0),
              builder: (_, child) {
                final animationValue = overlayCtrl.value?.value ?? 0.0;

                final scale = 1.0 - (0.15 * animationValue);
                return Transform.scale(scale: scale, child: child);
              },
              child: CustomScrollView(
                slivers: [
                  AnimatedExitSliverAppBar(controller: navCtrl.value),
                  addHeight(10, asSliver: true),
                  CustomSliverList(
                    ctrlCallback: (ctrl) => navCtrl.value = ctrl,
                  ),
                  addHeight(
                    bottomPadding + kBottomNavBarHeight + 12,
                    asSliver: true,
                  ),
                ],
              ),
            ),
          ),

          AnimatedBlurOverlay(
            controller: overlayCtrl.value,
            onTap: () => overlayCtrl.value?.reverse(),
          ),

          BottomNavBar(ctrlCallback: (ctrl) => overlayCtrl.value = ctrl),
        ],
      ),
    );
  }
}
