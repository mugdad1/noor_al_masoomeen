import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_al_masoomeen/data/content_repository.dart';
import 'package:noor_al_masoomeen/models/entry.dart';
import 'package:noor_al_masoomeen/utils/arabic_utils.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/constants.dart';
import 'package:noor_al_masoomeen/utils/masoom_data.dart';

class ContentProvider extends ChangeNotifier {
  final ContentRepository _repository;

  List<Entry> _entries = [];
  Entry? _dailyEntry;
  EntryCategory? _selectedCategory;
  int? _selectedMasoomIndex;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _midnightTimer;
  int _lastDay = DateTime.now().day;

  ContentProvider(this._repository) {
    loadContent();
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    super.dispose();
  }

  List<Entry> get entries {
    var result = _entries;
    if (_selectedCategory != null) {
      result = result.where((e) => e.category == _selectedCategory!.key).toList();
    }
    if (_selectedMasoomIndex != null) {
      result = result.where((e) => e.masoomIndex == _selectedMasoomIndex).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = normalizeArabic(_searchQuery.toLowerCase());
      result = result.where((e) {
        return normalizeArabic(e.englishText.toLowerCase()).contains(q) ||
            normalizeArabic(e.arabicText).contains(q);
      }).toList();
    }
    return result;
  }

  List<Entry> get allEntries => List.unmodifiable(_entries);
  Entry? get dailyEntry => _dailyEntry;
  EntryCategory? get selectedCategory => _selectedCategory;
  int? get selectedMasoomIndex => _selectedMasoomIndex;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadContent() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await _repository.loadContent(prefs);
      _entries = _repository.entries;
      _isLoading = false;
      notifyListeners();
      await _loadTodaysEntry(prefs);
      _startMidnightTimer();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'المحتوى غير متوفر. الرجاء إعادة التثبيت.';
      notifyListeners();
    }
  }

  Future<void> _loadTodaysEntry(SharedPreferences prefs) async {
    final key = _dateKey(DateTime.now());
    final raw = prefs.getString(kPrefsDailyHistory) ?? '{}';
    final history = Map<String, String>.from(jsonDecode(raw) as Map);
    final entryId = history[key];

    if (entryId != null) {
      _dailyEntry = _repository.byId(entryId);
    }

    if (_dailyEntry == null) {
      _pickAndSaveToday(prefs, key, history);
    } else {
      notifyListeners();
    }
  }

  void _pickAndSaveToday(SharedPreferences prefs, String key, Map<String, String> history) async {
    if (_entries.isEmpty) return;
    final entry = _repository.getRandom();
    _dailyEntry = entry;
    history[key] = entry.id;
    await prefs.setString(kPrefsDailyHistory, jsonEncode(history));
    notifyListeners();
    _updateWidget();
  }

  void _startMidnightTimer() {
    _midnightTimer?.cancel();
    _midnightTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      final now = DateTime.now();
      if (now.day != _lastDay) {
        _lastDay = now.day;
        final prefs = await SharedPreferences.getInstance();
        final key = _dateKey(now);
        final raw = prefs.getString(kPrefsDailyHistory) ?? '{}';
        final history = Map<String, String>.from(jsonDecode(raw) as Map);
        _pickAndSaveToday(prefs, key, history);
      }
    });
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, "0")}'
        '-${date.month.toString().padLeft(2, "0")}'
        '-${date.day.toString().padLeft(2, "0")}';
  }

  void setCategory(EntryCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  void setMasoom(int? index) {
    _selectedMasoomIndex = index;
    notifyListeners();
  }

  void clearMasoom() {
    _selectedMasoomIndex = null;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> _updateWidget() async {
    if (_dailyEntry == null) return;
    final masoom = masoomNames[_dailyEntry!.masoomIndex];
    final category = EntryCategory.fromKey(_dailyEntry!.category);
    await HomeWidget.saveWidgetData('widget_masoom', masoom?.ar ?? '');
    await HomeWidget.saveWidgetData('widget_text', _dailyEntry!.arabicText);
    await HomeWidget.saveWidgetData('widget_category', category.labelAr);
    await HomeWidget.updateWidget(androidName: 'NoorWidgetProvider');
  }

  void getRandom() async {
    if (_entries.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final key = _dateKey(DateTime.now());
    final raw = prefs.getString(kPrefsDailyHistory) ?? '{}';
    final history = Map<String, String>.from(jsonDecode(raw) as Map);
    _pickAndSaveToday(prefs, key, history);
  }

  Entry? getById(String id) {
    return _repository.byId(id);
  }
}
