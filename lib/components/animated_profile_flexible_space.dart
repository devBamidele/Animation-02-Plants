import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/card_data.dart';
import '../models/collection_card_transition_data.dart';

class AnimatedProfileFlexibleSpace extends HookWidget {
  const AnimatedProfileFlexibleSpace({
    super.key,
    required this.t,
    required this.card,
  });

  final double t;
  final CardData card;

  @override
  Widget build(BuildContext context) {
    final values = CardUIValues.lerp(
      t,
      transitionType: CardTransitionType.collectionToAppBar,
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
                child: Image.asset(card.profileImage, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: values.spacing),
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
                      fontWeight: FontWeight.w900,
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
    );
  }
}
