import 'package:animation_02_plants/components/profile_card.dart';
import 'package:animation_02_plants/models/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pages/page2.dart';

class CustomSliverList extends HookConsumerWidget {
  final ValueChanged<AnimationController>? ctrlCallback;

  const CustomSliverList({super.key, this.ctrlCallback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tappedIndex = useState<int?>(null);

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrlCallback?.call(controller);
      });

      return null;
    }, const []);

    void onCardTap(int index) {
      if (controller.isAnimating) return;

      tappedIndex.value = index;
      controller.forward();

      Navigator.push(
        context,
        CenterExpandPageRoute(
          page: Page2(listIndex: index),
          forwardDuration: controller.duration!,
          ref: ref,
        ),
      ).then((_) async {
        ref.read(htcListener.notifier).state = false;
        // Animate back in when popping
        await controller.reverse(); // <- REVERSE
        tappedIndex.value = null;
      });
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((_, index) {
        final isReversing = controller.status == AnimationStatus.reverse;

        final offsetTween = buildOffsetTween(
          index: index,
          tapped: tappedIndex.value,
          reverse: isReversing,
        );

        return AnimatedBuilder(
          animation: controller,
          builder: (_, child) {
            return SlideTransition(
              position: offsetTween.animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
              child: child,
            ); //
          },
          child: ProfileCard(
            data: userCards[index],
            onTap: () => onCardTap(index),
          ),
        );
      }, childCount: userCards.length),
    );
  }
}

Tween<Offset> buildOffsetTween({
  required int index,
  required int? tapped,
  required bool reverse,
}) {
  if (tapped == null) return Tween(begin: Offset.zero, end: Offset.zero);
  if (index < tapped) {
    return reverse
        ? Tween(begin: const Offset(0, -1), end: Offset.zero)
        : Tween(begin: Offset.zero, end: const Offset(0, -1));
  }
  if (index > tapped) {
    return reverse
        ? Tween(begin: const Offset(0, 1), end: Offset.zero)
        : Tween(begin: Offset.zero, end: const Offset(0, 1));
  }
  return Tween(begin: Offset.zero, end: Offset.zero);
}

class CenterExpandPageRoute<T> extends PageRouteBuilder<T> {
  CenterExpandPageRoute({
    required Widget page,
    required Duration forwardDuration,
    required WidgetRef ref,
  }) : super(
         transitionDuration: forwardDuration,
         reverseTransitionDuration: const Duration(milliseconds: 500),
         pageBuilder: (_, animation, _) {
           animation.addStatusListener((status) {
             if (status == AnimationStatus.completed) {
               ref.read(htcListener.notifier).state = true;
             }
           });
           return page;
         },
         transitionsBuilder: (_, animation, _, child) {
           final fadeIn = CurvedAnimation(
             parent: animation,
             curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
           );
           final scaleIn = Tween<double>(begin: .8, end: 1).animate(fadeIn);

           return ScaleTransition(
             scale: scaleIn,
             child: FadeTransition(opacity: fadeIn, child: child),
           );
         },
       );
}
