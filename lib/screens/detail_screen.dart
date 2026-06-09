import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:noor_al_masoomeen/models/entry.dart';
import 'package:noor_al_masoomeen/providers/settings_provider.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/masoom_data.dart';
import 'package:noor_al_masoomeen/widgets/category_badge.dart';
import 'package:noor_al_masoomeen/widgets/favorite_button.dart';

class DetailScreen extends StatelessWidget {
  final Entry entry;

  const DetailScreen({super.key, required this.entry});

  String _buildShareText(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    final masoom = masoomNames[entry.masoomIndex];
    final source = entry.source != null ? '\n- ${entry.source}' : '';

    if (settings.langOrder == LangOrder.enFirst) {
      final title = entry.titleEn ?? '';
      final header = masoom != null ? '${masoom.en}\n\n' : '';
      return '$header$title\n\n${entry.englishText}$source';
    }
    final title = entry.titleAr ?? '';
    final header = masoom != null ? '${masoom.ar}\n\n' : '';
    return '$header$title\n\n${entry.arabicText}$source';
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isAr = settings.langOrder == LangOrder.arFirst;
    final masoom = masoomNames[entry.masoomIndex];
    final entryCategory = EntryCategory.fromKey(entry.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? (entry.titleAr ?? '') : (entry.titleEn ?? ''),
          style: TextStyle(
            fontFamily: isAr ? 'NotoNaskhArabic' : null,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'مشاركة',
            onPressed: () {
              final text = _buildShareText(context);
              Share.share(text);
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'نسخ',
            onPressed: () {
              final text = _buildShareText(context);
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم النسخ')),
              );
            },
          ),
          FavoriteButton(entryId: entry.id),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryBadge(category: entryCategory),
            const SizedBox(height: 12),
            Text(
              masoom != null ? (isAr ? masoom.ar : masoom.en) : '',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: isAr ? 'NotoNaskhArabic' : null,
              ),
            ),
            const SizedBox(height: 8),
            if (isAr && entry.titleAr != null) ...[
              Text(
                entry.titleAr!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'NotoNaskhArabic',
                ),
              ),
            ],
            if (!isAr && entry.titleEn != null) ...[
              Text(
                entry.titleEn!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              isAr ? entry.arabicText : entry.englishText,
              textAlign: isAr ? TextAlign.right : TextAlign.left,
              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: isAr ? 21 : 16,
                height: 1.6,
                fontFamily: isAr ? 'NotoNaskhArabic' : null,
              ),
            ),
            if (entry.source != null) ...[
              const SizedBox(height: 16),
              Text(
                entry.source!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
