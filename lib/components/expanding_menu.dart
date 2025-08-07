import 'dart:math';

import 'package:flutter/material.dart';

class ExpandingMenu extends StatefulWidget {
  final VoidCallback? onTap;
  final ValueChanged<AnimationController>? controllerCallback;

  const ExpandingMenu({super.key, this.onTap, this.controllerCallback});

  @override
  State<ExpandingMenu> createState() => _ExpandingMenuState();
}

class _ExpandingMenuState extends State<ExpandingMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _containerColor;

  late final Animation<double> _rotation;
  late final Animation<Color?> _iconColor;

  late final List<Animation<double>> _staggeredAnimations;
  late final List<Animation<double>> _staggeredReverseAnimations;

  final icons = [
    Icons.play_arrow_rounded,
    Icons.camera_alt_rounded,
    Icons.folder_rounded,
  ];
  final fabSize = 75.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controllerCallback?.call(_controller);
    });

    _containerColor = ColorTween(
      begin: Colors.white,
      end: const Color(0xFF6769E0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees (1/8 turn)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _iconColor = ColorTween(
      begin: Colors.black87,
      end: Colors.white,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Forward animations: folder_rounded starts first
    _staggeredAnimations = List.generate(icons.length, (index) {
      final beginInterval = (icons.length - 1 - index) * 0.3; // 0.6, 0.3, 0.0
      final endInterval = 1.0;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(beginInterval, endInterval, curve: Curves.easeInOut),
      );
    });

    // Reverse animations: folder_rounded starts first, moves fastest
    _staggeredReverseAnimations = List.generate(icons.length, (index) {
      final beginInterval = index * 0.3; // 0.0, 0.3, 0.6
      final endInterval = 1.0;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(beginInterval, endInterval, curve: Curves.easeInOut),
      );
    });
  }

  void toggleMenu() {
    widget.onTap?.call();
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Flow(
          delegate: FlowBarDelegate(
            _staggeredAnimations,
            _staggeredReverseAnimations,
            _controller,
            fabSize: fabSize,
          ),
          children: icons
              .asMap()
              .entries
              .map(
                (entry) => Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    entry.value,
                    color: Colors.black.withValues(alpha: 0.8),
                    size: 28,
                  ),
                ),
              )
              .toList(),
        ),
        GestureDetector(
          onTap: () => toggleMenu(),
          child: AnimatedBuilder(
            animation: _containerColor,
            builder: (_, _) {
              return Container(
                width: fabSize,
                height: fabSize,
                decoration: BoxDecoration(
                  color: _containerColor.value,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .25),
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _iconColor,
                  builder: (_, _) {
                    return RotationTransition(
                      turns: _rotation,
                      child: Icon(Icons.add, color: _iconColor.value, size: 32),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FlowBarDelegate extends FlowDelegate {
  final List<Animation<double>> forwardAnimations;
  final List<Animation<double>> reverseAnimations;
  final AnimationController controller;
  final double fabSize;

  FlowBarDelegate(
    this.forwardAnimations,
    this.reverseAnimations,
    this.controller, {
    required this.fabSize,
  }) : super(
         repaint: Listenable.merge([
           ...forwardAnimations,
           ...reverseAnimations,
         ]),
       );

  final List<double> anglesInDegrees = [35, 90, 145]; // For 3 icons

  @override
  void paintChildren(FlowPaintingContext context) {
    final centerX = context.size.width / 2;
    final centerY = context.size.height - fabSize / 2;
    final radius = 130;

    for (int i = 0; i < context.childCount; i++) {
      final animation =
          controller.status == AnimationStatus.forward ||
              controller.status == AnimationStatus.completed
          ? forwardAnimations[i]
          : reverseAnimations[i];

      final angleDeg = anglesInDegrees[i];
      final angleRad = angleDeg * pi / 180;

      final dx = (radius * cos(angleRad)) * animation.value;
      final dy = (radius * sin(angleRad)) * animation.value;

      final baseX = centerX + dx;
      final baseY = centerY - dy;

      final scale = 0.5 + 0.5 * animation.value;
      final childWidth = context.getChildSize(i)!.width;
      final childHeight = context.getChildSize(i)!.height;

      final x = baseX - (childWidth * scale) / 2;
      final y = baseY - (childHeight * scale) / 2;

      context.paintChild(
        i,
        transform: Matrix4.identity()
          ..translate(x, y)
          ..scale(scale, scale),
        opacity: animation.value,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowBarDelegate oldDelegate) {
    return forwardAnimations != oldDelegate.forwardAnimations ||
        reverseAnimations != oldDelegate.reverseAnimations;
  }
}
