import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../helpers/helpers.dart';
import '../models/card_data.dart';
import 'collection_card.dart';

class CardStackWidget extends HookWidget {
  final void Function(CardData)? onCardDismissed;
  final List<CardData> collectionCards;

  const CardStackWidget({
    super.key,
    this.onCardDismissed,
    required this.collectionCards,
  });

  @override
  Widget build(BuildContext context) {
    final collectionCardsState = useState<List<CardData>>(collectionCards);
    final topCardOffset = useState(Offset.zero);
    final topCardOpacity = useState(1.0);
    final isTopCardDismissed = useState(false);
    final isPagePopping = useState(false);

    // Single controller reused for top card swipe animation
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    // Custom PopEntry to handle pop events
    final popEntry = useRef(
      CustomPopEntry(onPagePopping: () => isPagePopping.value = true),
    );

    // Register PopEntry with ModalRoute
    useEffect(() {
      late ModalRoute<Object?>? modalRoute;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        modalRoute = ModalRoute.of(context);
        modalRoute?.registerPopEntry(popEntry.value);
      });

      return () {
        modalRoute?.unregisterPopEntry(popEntry.value);
      };
    }, [context]);

    final displayCards = collectionCardsState.value
        .take(3)
        .toList()
        .reversed
        .toList();
    final cardCount = displayCards.length;

    const minScale = 0.8;
    const dismissScale = 0.9;
    const finalDismissScale = 0.9;

    final scaleStep = (1.0 - minScale) / (cardCount > 1 ? cardCount - 1 : 1);
    final offsetStep = 36;

    return FadeTransition(
      opacity: kAlwaysCompleteAnimation,
      child: Stack(
        children: List.generate(cardCount, (index) {
          final card = displayCards[index];
          final baseLeftPosition = (cardCount - 1 - index) * offsetStep;
          final baseScale = cardCount == 1
              ? 1.0
              : (index == cardCount - 1
                    ? 1.0
                    : (index == 0 && cardCount == 3 ? 0.8 : 0.9));

          final swipeProgress = (topCardOffset.value.dx / -300).clamp(0.0, 1.0);
          final nextIndex = index + 1;
          final targetLeftPosition = nextIndex < cardCount
              ? (cardCount - 1 - nextIndex) * offsetStep
              : baseLeftPosition;
          final targetScale = nextIndex < cardCount
              ? minScale + (nextIndex * scaleStep)
              : baseScale;

          final animatedLeft = index == cardCount - 1
              ? baseLeftPosition + topCardOffset.value.dx
              : baseLeftPosition +
                    (targetLeftPosition - baseLeftPosition) * swipeProgress;
          final animatedScale = index == cardCount - 1
              ? baseScale -
                    (baseScale -
                            (isTopCardDismissed.value
                                ? finalDismissScale
                                : dismissScale)) *
                        swipeProgress
              : baseScale + (targetScale - baseScale) * swipeProgress;

          void onDragUpdate(DragUpdateDetails details) {
            if (isTopCardDismissed.value || index != cardCount - 1) return;

            topCardOffset.value += Offset(details.delta.dx, 0);
            final dragDistance = topCardOffset.value.dx.abs();
            topCardOpacity.value = (1 - (dragDistance / 300).clamp(0, 1));
          }

          void onDragEnd(DragEndDetails details) {
            if (isTopCardDismissed.value || index != cardCount - 1) return;

            if (topCardOffset.value.dx < -150) {
              isTopCardDismissed.value = true;

              animationController.forward().then((_) {
                collectionCardsState.value = List.from(
                  collectionCardsState.value,
                )..remove(card);

                onCardDismissed?.call(card);

                topCardOffset.value = Offset.zero;
                topCardOpacity.value = 1.0;
                isTopCardDismissed.value = false;
                animationController.reset();
              });

              topCardOffset.value = const Offset(-600, 0);
              topCardOpacity.value = 0.0;
            } else {
              topCardOffset.value = Offset.zero;
              topCardOpacity.value = 1.0;
            }
          }

          if (index == cardCount - 1 &&
              isTopCardDismissed.value &&
              animationController.isCompleted) {
            return const SizedBox.shrink();
          }

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: animatedLeft,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: index < cardCount - 1 && isPagePopping.value ? 0.0 : 1.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: animatedScale,
                child: GestureDetector(
                  onHorizontalDragUpdate: onDragUpdate,
                  onHorizontalDragEnd: onDragEnd,
                  child: CollectionCard(card: card),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
