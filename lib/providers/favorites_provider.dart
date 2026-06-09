import 'package:flutter/foundation.dart';
import 'package:noor_al_masoomeen/data/favorites_service.dart';
import 'package:noor_al_masoomeen/models/entry.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _service;
  final List<Entry> Function() _getAllEntries;

  Set<String> _favoriteIds = {};
  List<Entry> _favoriteEntries = [];

  FavoritesProvider(this._service, this._getAllEntries) {
    loadFavorites();
  }

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  List<Entry> get favoriteEntries => List.unmodifiable(_favoriteEntries);

  Future<void> loadFavorites() async {
    _favoriteIds = await _service.getFavorites();
    _syncEntries();
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
      await _service.removeFavorite(id);
    } else {
      _favoriteIds.add(id);
      await _service.addFavorite(id);
    }
    _syncEntries();
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> sync() async {
    await loadFavorites();
  }

  void _syncEntries() {
    final all = _getAllEntries();
    _favoriteEntries = all.where((e) => _favoriteIds.contains(e.id)).toList();
  }
}
