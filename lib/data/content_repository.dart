import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:noor_al_masoomeen/models/entry.dart';
import 'package:noor_al_masoomeen/utils/categories.dart' as categories;
import 'package:noor_al_masoomeen/utils/daily_selector.dart';
import 'package:noor_al_masoomeen/utils/constants.dart';
import 'package:noor_al_masoomeen/utils/arabic_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentRepository {
  List<Entry> _entries = [];
  int _version = 1;

  List<Entry> get entries => List.unmodifiable(_entries);
  int get version => _version;

  Future<void> loadContent(SharedPreferences prefs) async {
    final data = await rootBundle.loadString('assets/data/content.json');
    await parseAndLoad(data, prefs);
  }

  Future<void> parseAndLoad(String data, SharedPreferences prefs) async {
    final json = jsonDecode(data) as Map<String, dynamic>;
    _version = json['version'] as int;
    final entryList = json['entries'] as List<dynamic>;
    _entries = entryList.map((e) => Entry.fromJson(e as Map<String, dynamic>)).toList();

    final storedVersion = prefs.getInt(kPrefsContentVersion);
    if (storedVersion != _version) {
      final favoriteIds = prefs.getStringList(kPrefsFavorites) ?? [];
      final validIds = _entries.map((e) => e.id).toSet();
      final cleaned = favoriteIds.where((id) => validIds.contains(id)).toList();
      await prefs.setStringList(kPrefsFavorites, cleaned);
      await prefs.setInt(kPrefsContentVersion, _version);
    }
  }

  Entry? byId(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Entry> byCategory(categories.EntryCategory category) {
    return _entries.where((e) => e.category == category.key).toList();
  }

  List<Entry> search(String query) {
    final q = normalizeArabic(query.toLowerCase());
    return _entries.where((e) {
      return normalizeArabic(e.englishText.toLowerCase()).contains(q) ||
          normalizeArabic(e.arabicText).contains(q);
    }).toList();
  }

  Entry getDaily(DateTime date, categories.EntryCategory category) {
    return pickDaily(_entries, date, category);
  }

  Entry getRandom() {
    final idx = DateTime.now().microsecondsSinceEpoch.abs() % _entries.length;
    return _entries[idx];
  }
}
