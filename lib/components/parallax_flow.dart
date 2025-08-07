import 'package:flutter/material.dart';

class ParallaxFlowDelegate extends FlowDelegate {
  final Offset swipeOffset;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  ParallaxFlowDelegate({
    required this.swipeOffset,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: ValueNotifier(swipeOffset));

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    // Keep the image 110% of the parent's size
    return BoxConstraints.tightFor(
      width: constraints.maxWidth * 1.3,
      height: constraints.maxHeight * 1.3,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final backgroundImageBox =
        backgroundImageKey.currentContext?.findRenderObject() as RenderBox?;
    final listItemBox = listItemContext.findRenderObject() as RenderBox?;

    if (backgroundImageBox == null || listItemBox == null) {
      context.paintChild(0);
      return;
    }

    // Calculate the initial offset to center the image
    final imageWidth = context.getChildSize(0)!.width;
    final imageHeight = context.getChildSize(0)!.height;
    final frameWidth = listItemBox.size.width;
    final frameHeight = listItemBox.size.height;

    // Center the image by offsetting it by half the difference in size
    final initialOffsetX = (frameWidth - imageWidth) / 2;
    final initialOffsetY = (frameHeight - imageHeight) / 2;

    // Calculate the parallax translation based on swipe offset
    final parallaxFactor = 0.5; // Adjust for parallax intensity
    final translateX = initialOffsetX + (-swipeOffset.dx * parallaxFactor);
    final translateY = initialOffsetY; // No vertical parallax in this case

    // Apply translation to the background image
    context.paintChild(
      0,
      transform: Matrix4.identity()..translate(translateX, translateY),
    );
  }

  @override
  bool shouldRepaint(covariant ParallaxFlowDelegate oldDelegate) {
    return swipeOffset != oldDelegate.swipeOffset ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}
