import 'package:flutter/material.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';

class CategoryBadge extends StatelessWidget {
  final EntryCategory category;

  const CategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: category.badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category.labelAr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
