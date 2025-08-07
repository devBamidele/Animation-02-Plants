import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySelector extends HookWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    final items = [
      'Nature',
      'City',
      'People',
      'Animals',
      'Travel',
      'Architecture',
      'Food',
      'Art',
      'Technology',
      'Sports',
      'Fashion',
      'Culture',
      'Adventure',
      'Music',
      'Lifestyle',
      'Nightlife',
    ];

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex.value == index;
          final item = items[index];

          return GestureDetector(
            onTap: () => selectedIndex.value = index,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              margin: EdgeInsets.only(right: index == items.length - 1 ? 0 : 6),
              decoration: isSelected
                  ? BoxDecoration(
                      color: const Color(0xFF444346),
                      borderRadius: BorderRadius.circular(999),
                    )
                  : null,
              child: Center(
                child: Text(
                  item,
                  style: GoogleFonts.workSans(
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: .4),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
