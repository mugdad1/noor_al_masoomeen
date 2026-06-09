import 'package:noor_al_masoomeen/models/entry.dart';
import 'package:noor_al_masoomeen/utils/categories.dart' as categories;

Entry pickDaily(List<Entry> eligible, DateTime date, categories.EntryCategory category) {
  final filtered = eligible
      .where((e) => e.isDailyEligible && e.category == category.key)
      .toList();
  if (filtered.isEmpty) {
    throw StateError('No daily-eligible entries for category ${category.key}');
  }
  final key = '${date.year.toString().padLeft(4, '0')}'
      '-${date.month.toString().padLeft(2, '0')}'
      '-${date.day.toString().padLeft(2, '0')}'
      '-${category.key}';
  final idx = key.hashCode.abs() % filtered.length;
  return filtered[idx];
}
