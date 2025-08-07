import 'package:animation_02_plants/components/animated_profile_sliver_bar.dart';
import 'package:animation_02_plants/components/animated_profile_sliver_grid.dart';
import 'package:animation_02_plants/components/delayed_opacity.dart';
import 'package:animation_02_plants/models/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../helpers/helpers.dart';

class Page3 extends HookWidget {
  const Page3({super.key, required this.cardData});

  final CardData cardData;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final routeAnimation = ModalRoute.of(context)?.animation;

    final gridAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );

    useEffect(() {
      gridAnimationController.forward();

      void listener(AnimationStatus status) {
        if (status == AnimationStatus.reverse && context.mounted) {
          gridAnimationController.reverse();
        }
      }

      routeAnimation?.addStatusListener(listener);

      return () => routeAnimation?.removeStatusListener(listener);
    }, const []);

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            AnimatedProfileSliverBar(card: cardData),
            _customSliverBody(card: cardData),
            AnimatedProfileSliverGrid(animCtrl: gridAnimationController),
            addHeight(bottomPadding, asSliver: true),
          ],
        ),
      ),
    );
  }
}

Widget _customSliverBody({required CardData card}) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: DelayedOpacity(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.location_pin, size: 16),
                addWidth(4),
                Text(
                  card.location,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            addHeight(16),
            Text(card.description, style: TextStyle(fontSize: 22)),
            addHeight(4),
          ],
        ),
      ),
    ),
  );
}
