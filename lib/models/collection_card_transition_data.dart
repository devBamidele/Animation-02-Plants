import 'dart:ui';

import 'package:flutter/cupertino.dart';

// Enum to specify transition type
enum CardTransitionType {
  collectionToAppBar, // Original transition (e.g., list to details)
  profileToCollection, // New transition with different values
}

class CardUIValues {
  final double avatarSize;
  final double leftPadding;
  final double bottomPadding;
  final double spacing;
  final double fontSizeName;
  final double fontSizePhotos;

  CardUIValues({
    required this.avatarSize,
    required this.leftPadding,
    required this.bottomPadding,
    required this.spacing,
    required this.fontSizeName,
    required this.fontSizePhotos,
  });

  factory CardUIValues.lerp(
    double t, {
    required CardTransitionType transitionType,
  }) {
    final easedT = Curves.linear.transform(t);
    switch (transitionType) {
      case CardTransitionType.collectionToAppBar:
        // Original values (e.g., for list to details transition)
        return CardUIValues(
          avatarSize: lerpDouble(48, 60, easedT)!,
          leftPadding: lerpDouble(18, 20, easedT)!,
          bottomPadding: lerpDouble(20, 24, easedT)!,
          spacing: lerpDouble(16, 20, easedT)!,
          fontSizeName: lerpDouble(18, 22, easedT)!,
          fontSizePhotos: lerpDouble(13, 18, easedT)!,
        );
      case CardTransitionType.profileToCollection:
        // New transition values (example values, adjust as needed)
        return CardUIValues(
          avatarSize: lerpDouble(48, 48, easedT)!,
          leftPadding: lerpDouble(12, 18, easedT)!,
          bottomPadding: lerpDouble(16, 20, easedT)!,
          spacing: lerpDouble(12, 16, easedT)!,
          fontSizeName: lerpDouble(18, 18, easedT)!,
          fontSizePhotos: lerpDouble(13, 13, easedT)!,
        );
    }
  }
}
