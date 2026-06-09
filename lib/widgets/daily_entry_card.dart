import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noor_al_masoomeen/models/entry.dart';
import 'package:noor_al_masoomeen/providers/settings_provider.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/masoom_data.dart';
import 'package:noor_al_masoomeen/widgets/category_badge.dart';
import 'package:noor_al_masoomeen/widgets/favorite_button.dart';

class DailyEntryCard extends StatelessWidget {
  final Entry entry;

  const DailyEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isAr = settings.langOrder == LangOrder.arFirst;
    final category = EntryCategory.fromKey(entry.category);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryBadge(category: category),
            const SizedBox(height: 16),
            Text(
              masoomNames[entry.masoomIndex] != null
                  ? (isAr ? masoomNames[entry.masoomIndex]!.ar : masoomNames[entry.masoomIndex]!.en)
                  : '',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: isAr ? 'NotoNaskhArabic' : null,
                  ),
            ),
            const SizedBox(height: 12),
            if (isAr && entry.titleAr != null) ...[
              Text(
                entry.titleAr!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'NotoNaskhArabic',
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
            ],
            if (!isAr && entry.titleEn != null) ...[
              Text(
                entry.titleEn!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              isAr ? entry.arabicText : entry.englishText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: isAr ? 21 : 16,
                    height: 1.8,
                    fontFamily: isAr ? 'NotoNaskhArabic' : null,
                  ),
              textAlign: isAr ? TextAlign.right : TextAlign.left,
            ),
            if (entry.source != null) ...[
              const SizedBox(height: 12),
              Text(
                entry.source!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(128),
                    ),
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FavoriteButton(entryId: entry.id),
            ),
          ],
        ),
      ),
    );
  }
}
