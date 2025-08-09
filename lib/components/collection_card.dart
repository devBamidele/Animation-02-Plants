import 'dart:ui';

import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../models/card_data.dart';
import '../models/collection_card_transition_data.dart';
import '../pages/page3.dart';

final kCollectionCardWidth = 370.0;
const kCollectionCardHeight = 595.0;

class CollectionCard extends StatelessWidget {
  final CardData card;

  const CollectionCard({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    final circularBorder = 36.0;
    return Container(
      clipBehavior: Clip.antiAlias,
      width: kCollectionCardWidth,
      height: kCollectionCardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circularBorder),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: card.uid,
              flightShuttleBuilder: (_, animation, flightDirection, _, _) {
                if (flightDirection == HeroFlightDirection.push) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (_, child) {
                      final easedT = Curves.easeOutCirc.transform(
                        animation.value,
                      );

                      final borderRadius = BorderRadius.circular(
                        lerpDouble(kProfileCardRadius, circularBorder, easedT)!,
                      );

                      return ClipRRect(
                        borderRadius: borderRadius,
                        child: child,
                      );
                    },
                    child: Image.asset(card.backgroundImage, fit: BoxFit.cover),
                  );
                } else {
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
                }
              },
              child: Image.asset(card.backgroundImage, fit: BoxFit.cover),
            ),
          ),

          // Details Hero
          Hero(
            tag: 'profile-${card.uid}',
            flightShuttleBuilder: (_, animation, flightDirection, _, _) {
              if (flightDirection == HeroFlightDirection.push) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (_, _) => _buildCardContent(
                    card,
                    animation.value,
                    transitionType: CardTransitionType.profileToCollection,
                  ),
                );
              } else {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (_, _) => _buildCardContent(card, animation.value),
                );
              }
            },
            child: _buildCardContent(card, 0),
          ),
        ],
      ),
    );
  }
}

Widget _buildCardContent(
  CardData card,
  double t, {
  CardTransitionType transitionType = CardTransitionType.collectionToAppBar,
}) {
  final values = CardUIValues.lerp(t, transitionType: transitionType);
  final speed = 800;

  return Builder(
    builder: (context) => Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: values.bottomPadding,
          left: values.leftPadding,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    reverseTransitionDuration: Duration(milliseconds: 1000),
                    transitionDuration: Duration(milliseconds: speed),
                    pageBuilder: (_, _, _) => Page3(cardData: card),
                    transitionsBuilder: (_, animation, _, child) {
                      final blurCurve = CurveTween(
                        curve: Interval(0, .5, curve: Curves.linear),
                      );

                      return Stack(
                        children: [
                          AnimatedBuilder(
                            animation: animation,
                            builder: (_, __) {
                              final value = blurCurve.transform(
                                animation.value,
                              );
                              return Container(
                                color: Colors.black.withValues(
                                  alpha: 1 * value,
                                ),
                              );
                            },
                          ),
                          slideFadeTransition(animation, child),
                        ],
                      );
                    },
                  ),
                );
              },
              child: SizedBox.square(
                dimension: values.avatarSize,
                child: ClipOval(
                  child: Image.asset(card.profileImage, fit: BoxFit.cover),
                ),
              ),
            ),
            addWidth(values.spacing),
            Material(
              type: MaterialType.transparency,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.name,
                    style: TextStyle(
                      fontSize: values.fontSizeName,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    card.subtitle,
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
    ),
  );
}
