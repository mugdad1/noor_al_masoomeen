import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_al_masoomeen/data/favorites_service.dart';

void main() {
  late FavoritesService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = FavoritesService();
  });

  group('FavoritesService', () {
    test('returns empty set initially', () async {
      final favorites = await service.getFavorites();
      expect(favorites, isEmpty);
    });

    test('adds a favorite', () async {
      await service.addFavorite('manqabah_001');
      final favorites = await service.getFavorites();
      expect(favorites, contains('manqabah_001'));
    });

    test('does not duplicate on double add', () async {
      await service.addFavorite('manqabah_001');
      await service.addFavorite('manqabah_001');
      final favorites = await service.getFavorites();
      expect(favorites.length, 1);
    });

    test('removes a favorite', () async {
      await service.addFavorite('manqabah_001');
      await service.removeFavorite('manqabah_001');
      final favorites = await service.getFavorites();
      expect(favorites, isEmpty);
    });

    test('isFavorite returns correct state', () async {
      expect(await service.isFavorite('manqabah_001'), false);
      await service.addFavorite('manqabah_001');
      expect(await service.isFavorite('manqabah_001'), true);
      await service.removeFavorite('manqabah_001');
      expect(await service.isFavorite('manqabah_001'), false);
    });

    test('persists across service instances', () async {
      await service.addFavorite('hadith_001');
      final newService = FavoritesService();
      final favorites = await newService.getFavorites();
      expect(favorites, contains('hadith_001'));
    });

    test('setFavorites replaces all', () async {
      await service.addFavorite('manqabah_001');
      await service.setFavorites({'hadith_001', 'khisal_001'});
      final favorites = await service.getFavorites();
      expect(favorites, contains('hadith_001'));
      expect(favorites, contains('khisal_001'));
      expect(favorites, isNot(contains('manqabah_001')));
    });

    test('handles multiple favorites', () async {
      await service.addFavorite('a');
      await service.addFavorite('b');
      await service.addFavorite('c');
      final favorites = await service.getFavorites();
      expect(favorites.length, 3);
    });
  });
}
