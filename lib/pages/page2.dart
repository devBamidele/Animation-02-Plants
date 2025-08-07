import 'package:animation_02_plants/components/card_stack.dart';
import 'package:animation_02_plants/helpers/helpers.dart';
import 'package:animation_02_plants/models/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/animated_blur_overlay.dart';
import '../components/bottom_nav_bar.dart';

class Page2 extends HookConsumerWidget {
  const Page2({super.key, required this.listIndex});

  final int listIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overlayCtrl = useState<AnimationController?>(null);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: AnimatedBuilder(
              animation: overlayCtrl.value ?? AlwaysStoppedAnimation(0),
              builder: (_, child) {
                final animationValue = overlayCtrl.value?.value ?? 0.0;

                final scale = 1.0 - (0.15 * animationValue);
                return Transform.scale(scale: scale, child: child);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  addHeight(10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              'COLLECTIONS',
                              style: GoogleFonts.workSans(
                                fontSize: 14,
                                color: Colors.white.withAlpha(220),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                            child: Text(
                              'Plants',
                              style: GoogleFonts.workSans(
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white24, // background color
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/menu.svg',
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                                semanticsLabel: 'Menu Icon',
                                width: 23,
                                height: 23,
                              ),
                            ),

                            addWidth(14),

                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white12, // background color
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/grid.svg',
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                                semanticsLabel: 'G Icon',
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: CardStackWidget(
                      collectionCards: userCards[listIndex].collection!,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedBlurOverlay(
            controller: overlayCtrl.value,
            onTap: () => overlayCtrl.value?.reverse(),
          ),

          if (ref.watch(htcListener))
            BottomNavBar(
              ctrlCallback: (ctrl) => overlayCtrl.value = ctrl,
              itemTapCallbacks: {0: () => Navigator.pop(context)},
            ),
        ],
      ),
    );
  }
}

final htcListener = StateProvider<bool>((ref) => false);
