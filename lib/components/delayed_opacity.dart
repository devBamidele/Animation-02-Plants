import 'package:flutter/material.dart';

class DelayedOpacity extends StatefulWidget {
  final Duration delay;
  final Widget child;

  const DelayedOpacity({
    this.delay = const Duration(milliseconds: 200),
    required this.child,
    super.key,
  });

  @override
  State<DelayedOpacity> createState() => _DelayedOpacityState();
}

class _DelayedOpacityState extends State<DelayedOpacity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.delay, vsync: this);

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start animation after delay for entry
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ModalRoute.of(context)?.animation?.addStatusListener((status) {
      if (status == AnimationStatus.reverse) {
        Future.delayed(widget.delay, () {
          if (mounted) {
            _controller.reverse();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (_, __) =>
          Opacity(opacity: _opacityAnimation.value, child: widget.child),
    );
  }
}
