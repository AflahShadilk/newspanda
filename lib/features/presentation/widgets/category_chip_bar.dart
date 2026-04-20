import 'package:flutter/material.dart';
import 'package:newspanda/core/constants/api_constants.dart';
import 'package:newspanda/core/theme/app_theme.dart';

class CategoryChipBar extends StatelessWidget {
  final String activeCategory;
  final void Function(String) onCategorySelected;

  const CategoryChipBar({
    super.key,
    required this.activeCategory,
    required this.onCategorySelected,
  });

  static const Map<String, IconData> _icons = {
    'general':       Icons.public_rounded,
    'technology':    Icons.memory_rounded,
    'sports':        Icons.sports_soccer_rounded,
    'business':      Icons.trending_up_rounded,
    'health':        Icons.favorite_rounded,
    'science':       Icons.science_rounded,
    'entertainment': Icons.movie_filter_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ApiConstants.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = ApiConstants.categories[index];
          final isActive = category == activeCategory;
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.chipSelected : AppTheme.chipUnselected,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isActive ? AppTheme.accentPrimary : AppTheme.divider,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[category] ?? Icons.circle,
                    size: 13,
                    color: isActive ? Colors.white : AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _capitalize(category),
                    style: TextStyle(
                      color: isActive ? Colors.white : AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}