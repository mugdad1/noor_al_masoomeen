import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noor_al_masoomeen/models/entry.dart';
import 'package:noor_al_masoomeen/providers/settings_provider.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/masoom_data.dart';
import 'package:noor_al_masoomeen/widgets/category_badge.dart';
import 'package:noor_al_masoomeen/widgets/favorite_button.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;
  final VoidCallback? onTap;

  const EntryCard({super.key, required this.entry, this.onTap});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isAr = settings.langOrder == LangOrder.arFirst;
    final masoom = masoomNames[entry.masoomIndex];
    final entryCategory = EntryCategory.fromKey(entry.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CategoryBadge(category: entryCategory),
                  const Spacer(),
                  FavoriteButton(entryId: entry.id),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                masoom != null ? (isAr ? masoom.ar : masoom.en) : '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: isAr ? 'NotoNaskhArabic' : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isAr ? entry.arabicText : entry.englishText,
                textAlign: isAr ? TextAlign.right : TextAlign.left,
                textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: isAr ? 'NotoNaskhArabic' : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
