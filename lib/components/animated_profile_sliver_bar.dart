import 'package:animation_02_plants/components/animated_profile_flexible_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../helpers/helpers.dart';
import '../models/card_data.dart';
import 'delayed_opacity.dart';

class AnimatedProfileSliverBar extends HookWidget {
  final CardData card;
  final double expandedHeight;

  const AnimatedProfileSliverBar({
    this.expandedHeight = 280,
    required this.card,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final circularBorder = 36.0;

    return SliverAppBar(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.black,
      pinned: true,
      expandedHeight: expandedHeight,
      centerTitle: false,
      titleSpacing: 0,
      leading: Builder(
        builder: (context) {
          return DelayedOpacity(
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back', // Accessibility
            ),
          );
        },
      ),
      title: LayoutBuilder(
        builder: (ctx, cts) {
          // Calculate the percentage collapsed
          final settings = ctx
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();

          final deltaExtent =
              ((settings?.maxExtent ?? 0) - (settings?.minExtent ?? 0)).clamp(
                1e-5,
                double.infinity,
              );

          final t =
              ((settings?.maxExtent ?? 0) - (settings?.currentExtent ?? 0)) /
              deltaExtent;

          // Apply your desired curve here
          final curvedT = Curves.easeInExpo.transform(t.clamp(0.0, 1.0));

          return Opacity(
            opacity: curvedT,
            child: Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 40,
                    child: ClipOval(
                      child: Image.asset(card.profileImage, fit: BoxFit.cover),
                    ),
                  ),
                  addWidth(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        card.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        card.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: .9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: card.uid,
                flightShuttleBuilder: (_, animation, _, _, _) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (_, child) {
                      final easedT = Curves.easeOutCirc.transform(
                        animation.value,
                      );

                      final borderRadius = BorderRadius.circular(
                        circularBorder * (1 - easedT),
                      );

                      return ClipRRect(
                        borderRadius: borderRadius,
                        child: child,
                      );
                    },
                    child: Image.asset(card.backgroundImage, fit: BoxFit.cover),
                  );
                },
                child: Image.asset(card.backgroundImage, fit: BoxFit.cover),
              ),
            ),

            Hero(
              tag: 'profile-${card.uid}',
              flightShuttleBuilder: (_, animation, _, _, _) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (_, _) => AnimatedProfileFlexibleSpace(
                    card: card,
                    t: animation.value,
                  ),
                );
              },
              child: AnimatedProfileFlexibleSpace(card: card, t: 1),
            ),
          ],
        ),
      ),
    );
  }
}
