import 'package:flutter_test/flutter_test.dart';
import 'package:noor_al_masoomeen/models/entry.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/daily_selector.dart';

void main() {
  final sampleEntries = [
    const Entry(
      id: 'manqabah_001', category: 'manqabah', masoomIndex: 1,
      arabicText: 'نص', englishText: 'Text 1', isDailyEligible: true,
    ),
    const Entry(
      id: 'manqabah_002', category: 'manqabah', masoomIndex: 2,
      arabicText: 'نص', englishText: 'Text 2', isDailyEligible: true,
    ),
    const Entry(
      id: 'hadith_001', category: 'hadith', masoomIndex: 3,
      arabicText: 'نص', englishText: 'Text 3', isDailyEligible: true,
    ),
    const Entry(
      id: 'khisal_001', category: 'khisal', masoomIndex: 4,
      arabicText: 'نص', englishText: 'Text 4', isDailyEligible: true,
    ),
    const Entry(
      id: 'manqabah_003', category: 'manqabah', masoomIndex: 5,
      arabicText: 'نص', englishText: 'Text 5', isDailyEligible: false,
    ),
  ];

  group('pickDaily', () {
    test('returns same result for same date and category', () {
      final date = DateTime(2026, 6, 9);
      final first = pickDaily(sampleEntries, date, EntryCategory.manqabah);
      final second = pickDaily(sampleEntries, date, EntryCategory.manqabah);
      expect(first.id, second.id);
    });

    test('returns different result for different categories', () {
      final date = DateTime(2026, 6, 9);
      final manqabah = pickDaily(sampleEntries, date, EntryCategory.manqabah);
      final hadith = pickDaily(sampleEntries, date, EntryCategory.hadith);
      expect(manqabah.id, isNot(hadith.id));
    });

    test('can return different results for different dates', () {
      final results = List.generate(
        100,
        (i) => pickDaily(
          sampleEntries,
          DateTime(2026, 1, 1).add(Duration(days: i)),
          EntryCategory.manqabah,
        ).id,
      );
      expect(results.toSet().length, greaterThan(1));
    });

    test('filters by category correctly', () {
      final date = DateTime(2026, 6, 9);
      final result = pickDaily(sampleEntries, date, EntryCategory.hadith);
      expect(result.category, 'hadith');
    });

    test('throws StateError when no eligible entries', () {
      final date = DateTime(2026, 6, 9);
      expect(
        () => pickDaily([], date, EntryCategory.manqabah),
        throwsStateError,
      );
    });

    test('excludes non-daily-eligible entries', () {
      final date = DateTime(2026, 6, 9);
      final result = pickDaily(sampleEntries, date, EntryCategory.manqabah);
      expect(result.isDailyEligible, true);
    });

    test('deterministic across repeated calls', () {
      final date = DateTime(2026, 6, 9);
      final results = List.generate(
        10,
        (_) => pickDaily(sampleEntries, date, EntryCategory.manqabah).id,
      );
      expect(results.toSet().length, 1);
    });
  });
}
