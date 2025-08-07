import 'package:flutter/material.dart';

class AnimatedBlurOverlay extends StatelessWidget {
  final AnimationController? controller;
  final VoidCallback? onTap;

  const AnimatedBlurOverlay({super.key, required this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    final animation = controller ?? const AlwaysStoppedAnimation(0.0);

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final value = controller?.value ?? 0.0;

        return Positioned.fill(
          child: IgnorePointer(
            ignoring: value == 0.0,
            child: GestureDetector(
              onTap: value > 0 ? onTap : null,
              child: Container(
                color: Colors.black.withValues(alpha: .7 * value),
              ),
            ),
          ),
        );
      },
    );
  }
}
