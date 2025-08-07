import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AnimatedProfileSliverGrid extends StatelessWidget {
  const AnimatedProfileSliverGrid({super.key, required this.animCtrl});

  final AnimationController animCtrl;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childCount: 9,
        itemBuilder: (_, index) {
          final animation = CurvedAnimation(
            parent: animCtrl,
            curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutCirc),
            reverseCurve: Interval(
              index * 0.1,
              1.0,
              curve: Curves.easeInOutQuad,
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final itemWidth =
                  (context.findRenderObject() as RenderBox?)?.size.width ?? 0;
              final screenWidth = MediaQuery.of(context).size.width;
              final centerX = screenWidth / 2;

              final initialX = index.isOdd
                  ? -itemWidth
                  : centerX - (itemWidth / 2);
              final targetX = index.isOdd ? (centerX) - (itemWidth) - 30 : 0;

              final translateX =
                  lerpDouble(initialX, targetX, animation.value) ?? 0.0;

              final scale = animation.value;
              final translateY = (1.0 - animation.value) * 400;

              return Transform(
                transform: Matrix4.identity()
                  ..translate(translateX, translateY)
                  ..scale(scale, scale),
                alignment: Alignment.bottomCenter,
                child: child,
              );
            },
            child: Container(
              height: 100.0 + (index % 5) * 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/pictures/grid/p${index + 1}.jpg',

                    // Inverted Order
                    // 'assets/pictures/grid/p${9 - index}.jpg',
                  ), // or .png
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
