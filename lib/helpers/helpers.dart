import 'package:flutter/material.dart';

Widget addHeight(double h, {bool asSliver = false}) {
  final box = SizedBox(height: h);
  return asSliver ? SliverToBoxAdapter(child: box) : box;
}

Widget addWidth(double w) => SizedBox(width: w);

Color primaryColor = const Color(0xFFE0E1DD);

List<Widget> spacedIcons(List<Widget> items, {double spacing = 28}) {
  final spaced = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    spaced.add(items[i]);
    if (i < items.length - 1) {
      spaced.add(SizedBox(width: spacing));
    }
  }
  return spaced;
}

Widget slideFadeTransition(Animation<double> animation, Widget child) {
  final offsetTween = Tween(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.ease));
  final fadeTween = Tween(begin: 0.0, end: 1.0);

  return SlideTransition(
    position: animation.drive(offsetTween),
    child: FadeTransition(opacity: animation.drive(fadeTween), child: child),
  );
}

// Custom PopEntry implementation
class CustomPopEntry implements PopEntry {
  final VoidCallback? _onPagePopping;

  CustomPopEntry({VoidCallback? onPagePopping})
    : _onPagePopping = onPagePopping;

  @override
  ValueNotifier<bool> get canPopNotifier => ValueNotifier<bool>(true);

  @override
  Future<void> onPopInvokedWithResult(didPop, _) async {
    if (didPop) _onPagePopping?.call();
  }

  @override
  void onPopInvoked(bool didPop) {}
}

const kBottomNavBarHeight = 60.0;
const kProfileCardRadius = 30.0;
