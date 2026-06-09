import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_al_masoomeen/data/content_repository.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/constants.dart';

void main() {
  late ContentRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = ContentRepository();
  });

  group('ContentRepository', () {
    test('parses and loads entries from JSON string', () async {
      final json = jsonEncode({
        'version': 1,
        'updated': '2026-06-04',
        'entries': [
          {
            'id': 'manqabah_001',
            'category': 'manqabah',
            'masoomIndex': 1,
            'arabicText': 'نص عربي',
            'englishText': 'English text',
            'isDailyEligible': true,
          },
        ],
      });

      final prefs = await SharedPreferences.getInstance();
      await repository.parseAndLoad(json, prefs);

      expect(repository.entries.length, 1);
      expect(repository.entries.first.id, 'manqabah_001');
      expect(repository.version, 1);
    });

    test('handles stale favorite cleanup on version change', () async {
      SharedPreferences.setMockInitialValues({
        kPrefsFavorites: <String>['stale_id_001', 'manqabah_001'],
        kPrefsContentVersion: 0,
      });

      final json = jsonEncode({
        'version': 2,
        'updated': '2026-06-09',
        'entries': [
          {
            'id': 'manqabah_001',
            'category': 'manqabah',
            'masoomIndex': 1,
            'arabicText': 'نص',
            'englishText': 'Text',
            'isDailyEligible': true,
          },
        ],
      });

      final prefs = await SharedPreferences.getInstance();
      await repository.parseAndLoad(json, prefs);

      final saved = prefs.getStringList(kPrefsFavorites);
      expect(saved, ['manqabah_001']);
      expect(prefs.getInt(kPrefsContentVersion), 2);
    });

    test('byId returns null for missing entry', () {
      expect(repository.byId('nonexistent'), isNull);
    });

    test('byCategory returns filtered entries', () async {
      final json = jsonEncode({
        'version': 1,
        'updated': '2026-06-04',
        'entries': [
          {
            'id': 'm001', 'category': 'manqabah', 'masoomIndex': 1,
            'arabicText': 'أ', 'englishText': 'a', 'isDailyEligible': true,
          },
          {
            'id': 'h001', 'category': 'hadith', 'masoomIndex': 1,
            'arabicText': 'ب', 'englishText': 'b', 'isDailyEligible': true,
          },
        ],
      });

      final prefs = await SharedPreferences.getInstance();
      await repository.parseAndLoad(json, prefs);

      final manqabah = repository.byCategory(EntryCategory.manqabah);
      expect(manqabah.length, 1);
      expect(manqabah.first.id, 'm001');

      final hadith = repository.byCategory(EntryCategory.hadith);
      expect(hadith.length, 1);
      expect(hadith.first.id, 'h001');
    });

    test('search finds matching entries', () async {
      final json = jsonEncode({
        'version': 1,
        'updated': '2026-06-04',
        'entries': [
          {
            'id': 'm001', 'category': 'manqabah', 'masoomIndex': 1,
            'arabicText': 'علي', 'englishText': 'Ali', 'isDailyEligible': true,
          },
          {
            'id': 'h001', 'category': 'hadith', 'masoomIndex': 1,
            'arabicText': 'علم', 'englishText': 'Knowledge', 'isDailyEligible': true,
          },
        ],
      });

      final prefs = await SharedPreferences.getInstance();
      await repository.parseAndLoad(json, prefs);

      expect(repository.search('Ali').length, 1);
      expect(repository.search('علم').length, 1);
      expect(repository.search('nonexistent').length, 0);
    });

    test('search strips tashkeel from Arabic text', () async {
      final prefs = await SharedPreferences.getInstance();
      await repository.parseAndLoad(jsonEncode({
        'version': 1,
        'updated': '2026-06-09',
        'entries': [
          {
            'id': 'm001', 'category': 'manqabah', 'masoomIndex': 1,
            'arabicText': 'عَلِيٌّ', 'englishText': 'Ali tashkeel', 'isDailyEligible': true,
          },
          {
            'id': 'h001', 'category': 'hadith', 'masoomIndex': 1,
            'arabicText': 'بِسْمِ ٱللَّهِ', 'englishText': 'Bismillah', 'isDailyEligible': true,
          },
        ],
      }), prefs);

      expect(repository.search('علي').length, 1);
      expect(repository.search('بسم الله').length, 1);
      expect(repository.search('عَلِيّ').length, 1);
      expect(repository.search('Ali tashkeel').length, 1);
    });
  });
}
