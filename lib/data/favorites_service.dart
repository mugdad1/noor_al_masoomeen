import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_al_masoomeen/utils/constants.dart';

class FavoritesService {
  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(kPrefsFavorites)?.toSet() ?? {};
  }

  Future<void> addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(kPrefsFavorites) ?? [];
    if (!list.contains(id)) {
      list.add(id);
      await prefs.setStringList(kPrefsFavorites, list);
    }
  }

  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(kPrefsFavorites) ?? [];
    list.remove(id);
    await prefs.setStringList(kPrefsFavorites, list);
  }

  Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(kPrefsFavorites) ?? [];
    return list.contains(id);
  }

  Future<void> setFavorites(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(kPrefsFavorites, ids.toList());
  }
}
