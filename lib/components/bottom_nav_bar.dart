import 'dart:io';
import 'dart:ui';

import 'package:animation_02_plants/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'expanding_menu.dart';

class BottomNavBar extends HookWidget {
  final double fabSize;
  final double barHeight;
  final int initialIndex;

  final ValueChanged<AnimationController?> ctrlCallback;
  final Map<int, VoidCallback>? itemTapCallbacks;

  const BottomNavBar({
    super.key,
    this.fabSize = 75,
    this.barHeight = kBottomNavBarHeight,
    this.initialIndex = 0,
    required this.ctrlCallback,
    this.itemTapCallbacks,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(initialIndex);
    final expandCtrl = useState<AnimationController?>(null);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Notify parent of controller changes
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrlCallback(expandCtrl.value);
      });

      return null;
    }, [expandCtrl.value]);

    return Positioned(
      bottom: Platform.isAndroid ? 10 : 0,
      left: 0,
      right: 0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          LayoutBuilder(
            builder: (_, constraints) {
              return AnimatedBuilder(
                animation: expandCtrl.value ?? AlwaysStoppedAnimation(0),
                builder: (_, child) {
                  final width =
                      constraints.maxWidth *
                      (1.0 - (expandCtrl.value?.value ?? 0.0));
                  return Center(
                    child: SizedBox(
                      width: width,
                      height: barHeight + bottomPadding,
                      child: width > 0 ? child : null,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: bottomPadding,
                    left: 14,
                    right: 14,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: barHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .8),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: spacedIcons(
                              List.generate(5, (index) {
                                if (index == 2) return addWidth(75);

                                final isSelected = selectedIndex.value == index;

                                return GestureDetector(
                                  onTap: () {
                                    selectedIndex.value = index;
                                    itemTapCallbacks?[index]?.call();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: index == 4
                                        ? const CircleAvatar(
                                            radius: 19,
                                            backgroundImage: NetworkImage(
                                              'https://i.pravatar.cc/150?img=3',
                                            ),
                                          )
                                        : Icon(
                                            navBarItems[index],
                                            size: isSelected ? 28 : 26,
                                            color: isSelected
                                                ? const Color(0xFF6769E0)
                                                : Colors.black.withValues(
                                                    alpha: .7,
                                                  ),
                                          ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: bottomPadding + (barHeight / 2) - (fabSize / 2),
            child: SizedBox(
              width: fabSize + 240, // fabSize + 2 * radius (120 * 2)
              height: fabSize + 130, // fabSize + radius (upward expansion)
              child: ExpandingMenu(
                onTap: () {
                  selectedIndex.value = 2;
                },
                controllerCallback: (ctrl) {
                  expandCtrl.value = ctrl;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final navBarItems = [
  Icons.home,
  Icons.search,
  Icons.add,
  Icons.notifications_rounded,
  null,
];
