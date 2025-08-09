import 'package:card_swiper/card_swiper.dart';
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
    final showSwiper = useState(false);
    final isPopping = useState(false);

    final popEntry = useRef(
      CustomPopEntry(onPagePopping: () => isPopping.value = true),
    );

    useEffect(() {
      late ModalRoute<Object?>? modalRoute;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        modalRoute = ModalRoute.of(context);
        modalRoute?.registerPopEntry(popEntry.value);
      });

      return () => modalRoute?.unregisterPopEntry(popEntry.value);
    }, [context]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 2000), () {
          if (!context.mounted) return;
          showSwiper.value = true;
        });
      });
      return null;
    }, []);

    return Stack(
      children: [
        Swiper(
          index: 0,
          axisDirection: AxisDirection.right,
          itemBuilder: (_, index) =>
              CollectionCard(card: collectionCards[index]),
          itemCount: collectionCards.length,
          itemWidth: kCollectionCardWidth,
          itemHeight: kCollectionCardHeight,
        ), //
        if (!showSwiper.value && !isPopping.value)
          Transform.translate(
            offset: Offset(1, 0),
            child: SizedBox(
              height: kCollectionCardHeight,
              width: kCollectionCardWidth,
              child: CollectionCard(card: collectionCards[0]),
            ),
          ),
      ],
    );
  }
}
