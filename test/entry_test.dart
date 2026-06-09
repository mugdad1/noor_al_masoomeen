import 'package:flutter_test/flutter_test.dart';
import 'package:noor_al_masoomeen/models/entry.dart';

void main() {
  group('Entry fromJson', () {
    test('parses full JSON correctly', () {
      final json = {
        'id': 'manqabah_001',
        'category': 'manqabah',
        'masoomIndex': 3,
        'arabicText': 'نص عربي',
        'englishText': 'English text',
        'source': 'Source ref',
        'titleEn': 'English Title',
        'titleAr': 'العنوان العربي',
        'isDailyEligible': true,
      };
      final entry = Entry.fromJson(json);
      expect(entry.id, 'manqabah_001');
      expect(entry.category, 'manqabah');
      expect(entry.masoomIndex, 3);
      expect(entry.arabicText, 'نص عربي');
      expect(entry.englishText, 'English text');
      expect(entry.source, 'Source ref');
      expect(entry.titleEn, 'English Title');
      expect(entry.titleAr, 'العنوان العربي');
      expect(entry.isDailyEligible, true);
    });

    test('handles missing optional fields', () {
      final json = {
        'id': 'hadith_001',
        'category': 'hadith',
        'masoomIndex': 1,
        'arabicText': 'نص',
        'englishText': 'Text',
      };
      final entry = Entry.fromJson(json);
      expect(entry.id, 'hadith_001');
      expect(entry.source, isNull);
      expect(entry.titleEn, isNull);
      expect(entry.titleAr, isNull);
      expect(entry.isDailyEligible, true);
    });

    test('defaults isDailyEligible to true', () {
      final json = {
        'id': 'khisal_001',
        'category': 'khisal',
        'masoomIndex': 7,
        'arabicText': 'نص',
        'englishText': 'Text',
        'isDailyEligible': false,
      };
      final entry = Entry.fromJson(json);
      expect(entry.isDailyEligible, false);
    });
  });

  group('Entry toJson', () {
    test('round-trip preserves all fields', () {
      const original = Entry(
        id: 'manqabah_001',
        category: 'manqabah',
        masoomIndex: 3,
        arabicText: 'نص عربي',
        englishText: 'English text',
        source: 'Source ref',
        titleEn: 'English Title',
        titleAr: 'العنوان العربي',
        isDailyEligible: true,
      );
      final json = original.toJson();
      final restored = Entry.fromJson(json);
      expect(restored.id, original.id);
      expect(restored.category, original.category);
      expect(restored.masoomIndex, original.masoomIndex);
      expect(restored.arabicText, original.arabicText);
      expect(restored.englishText, original.englishText);
      expect(restored.source, original.source);
      expect(restored.titleEn, original.titleEn);
      expect(restored.titleAr, original.titleAr);
      expect(restored.isDailyEligible, original.isDailyEligible);
    });
  });
}
