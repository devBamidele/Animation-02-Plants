import 'package:animation_02_plants/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

import 'category_selector.dart';

class AnimatedExitSliverAppBar extends HookWidget {
  final double expandedHeight;
  final AnimationController? controller;

  const AnimatedExitSliverAppBar({
    super.key,
    this.expandedHeight = 148,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Create a fallback controller only if the real one is null
    final fallbackController = useAnimationController(duration: Duration.zero);
    final safeController = controller ?? fallbackController;

    return SliverAppBar(
      surfaceTintColor: Colors.black,
      backgroundColor: Colors.black,
      pinned: true,
      expandedHeight: expandedHeight,
      automaticallyImplyLeading: false,
      centerTitle: false,

      title: AnimatedBuilder(
        animation: safeController,
        builder: (_, child) {
          return Opacity(
            opacity: 1 - safeController.value,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0, -1),
                  ).animate(
                    CurvedAnimation(
                      parent: safeController,
                      curve: Curves.easeInOut,
                    ),
                  ),
              child: child,
            ),
          );
        },
        child: LayoutBuilder(
          builder: (ctx, _) {
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
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  'For You',
                  style: GoogleFonts.workSans(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            );
          },
        ),
      ),

      flexibleSpace: AnimatedBuilder(
        animation: safeController,
        builder: (_, child) {
          final animation = CurvedAnimation(
            parent: safeController,
            curve: Curves.easeInOutQuad,
          );

          final slide = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0, -1),
          ).animate(animation);

          final fade = Tween<double>(begin: 1, end: 0).animate(animation);

          final scale = Tween<double>(begin: 1.0, end: 0.85).animate(animation);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: ScaleTransition(
                scale: scale,
                alignment: Alignment.centerLeft,
                child: child,
              ),
            ),
          );
        },
        child: FlexibleSpaceBar(
          background: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addHeight(10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  'SATURDAY, JULY 19',
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: .85),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 8),
                child: Text(
                  'For You',
                  style: GoogleFonts.workSans(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const CategorySelector(),
            ],
          ),
        ),
      ),
    );
  }
}
