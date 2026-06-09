import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/constants.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  LangOrder _langOrder = LangOrder.arFirst;
  double _fontSize = 1.0;
  bool _notifEnabled = false;
  TimeOfDay _notifTime = const TimeOfDay(hour: 8, minute: 0);

  SettingsProvider() {
    loadSettings();
  }

  ThemeMode get themeMode => _themeMode;
  LangOrder get langOrder => _langOrder;
  double get fontSize => _fontSize;
  bool get notifEnabled => _notifEnabled;
  TimeOfDay get notifTime => _notifTime;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = _parseThemeMode(prefs.getString(kPrefsThemeMode));
    _langOrder = _parseLangOrder(prefs.getString(kPrefsLangOrder));
    _fontSize = prefs.getDouble(kPrefsFontSize) ?? 1.0;
    _notifEnabled = prefs.getBool(kPrefsNotifEnabled) ?? false;
    final timeStr = prefs.getString(kPrefsNotifTime);
    if (timeStr != null) {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        _notifTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefsThemeMode, mode.name);
    notifyListeners();
  }

  Future<void> setLangOrder(LangOrder order) async {
    _langOrder = order;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefsLangOrder, order.name);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(kPrefsFontSize, size);
    notifyListeners();
  }

  Future<void> setNotifEnabled(bool enabled) async {
    _notifEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefsNotifEnabled, enabled);
    notifyListeners();
  }

  Future<void> setNotifTime(TimeOfDay time) async {
    _notifTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      kPrefsNotifTime,
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
    );
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  LangOrder _parseLangOrder(String? value) {
    switch (value) {
      case 'en_first':
        return LangOrder.enFirst;
      default:
        return LangOrder.arFirst;
    }
  }
}
