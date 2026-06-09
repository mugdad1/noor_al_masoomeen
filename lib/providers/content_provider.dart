import 'package:flutter/foundation.dart' hide Category;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_al_masoomeen/data/content_repository.dart';
import 'package:noor_al_masoomeen/models/entry.dart';
import 'package:noor_al_masoomeen/utils/arabic_utils.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';

class ContentProvider extends ChangeNotifier {
  final ContentRepository _repository;

  List<Entry> _entries = [];
  Entry? _dailyEntry;
  EntryCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  ContentProvider(this._repository) {
    loadContent();
  }

  List<Entry> get entries {
    var result = _entries;
    if (_selectedCategory != null) {
      result = result.where((e) => e.category == _selectedCategory!.key).toList();
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
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'المحتوى غير متوفر. الرجاء إعادة التثبيت.';
      notifyListeners();
    }
  }

  void setCategory(EntryCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void getDaily(DateTime date, EntryCategory category) {
    try {
      _dailyEntry = _repository.getDaily(date, category);
      notifyListeners();
    } catch (e) {
      _dailyEntry = null;
      _errorMessage = 'لا توجد إدخالات متاحة في هذه الفئة بعد.';
      notifyListeners();
    }
  }

  void getRandom() {
    _dailyEntry = _repository.getRandom();
    notifyListeners();
  }

  Entry? getById(String id) {
    return _repository.byId(id);
  }
}
