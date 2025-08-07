import 'dart:ui';

import 'package:animation_02_plants/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../models/card_data.dart';
import '../models/collection_card_transition_data.dart';

class ProfileCard extends StatelessWidget {
  final CardData data;
  final VoidCallback? onTap; // Added onTap callback parameter

  const ProfileCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kProfileCardRadius),
              child: GestureDetector(
                onTap: onTap,
                child: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: Hero(
                        tag: data.uid,
                        flightShuttleBuilder:
                            (
                              flightContext,
                              animation,
                              flightDirection,
                              fromHeroContext,
                              toHeroContext,
                            ) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (_, child) {
                                  final easedT = Curves.easeOutCirc.transform(
                                    animation.value,
                                  );
                                  final borderRadius = BorderRadius.circular(
                                    lerpDouble(30, 36, easedT)!,
                                  );

                                  return ClipRRect(
                                    borderRadius: borderRadius,
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  data.backgroundImage,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                        child: Image.asset(
                          data.backgroundImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Text + profile overlay
                    Hero(
                      tag: 'profile-${data.uid}',
                      flightShuttleBuilder:
                          (
                            flightContext,
                            animation,
                            flightDirection,
                            fromHeroContext,
                            toHeroContext,
                          ) {
                            return AnimatedBuilder(
                              animation: animation,
                              builder: (_, _) =>
                                  _buildCardContent(data, animation.value),
                            );
                          },
                      child: _buildCardContent(data, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCardContent(CardData data, double t) {
  final values = CardUIValues.lerp(
    t,
    transitionType: CardTransitionType.profileToCollection,
  );
  return Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: EdgeInsets.only(
        bottom: values.bottomPadding,
        left: values.leftPadding,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: values.avatarSize,
            child: ClipOval(
              child: Image.asset(data.profileImage, fit: BoxFit.cover),
            ),
          ),
          addWidth(values.spacing),
          Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: TextStyle(
                    fontSize: values.fontSizeName,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: values.fontSizePhotos,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: .9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
