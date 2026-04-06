import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  // 1. Load saved language when app starts
  Future<void> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');

    if (languageCode != null) {
      _appLocale = Locale(languageCode);
    } else {
      _appLocale = null; // No language selected yet
    }
    notifyListeners();
  }

  // 2. Change language and save it to storage
  Future<void> changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();

    // If the new language is different, update it
    if (_appLocale == type) return;

    if (type == const Locale('mr')) {
      _appLocale = const Locale('mr');
      await prefs.setString('language_code', 'mr');
    } else if (type == const Locale('hi')) {
      _appLocale = const Locale('hi');
      await prefs.setString('language_code', 'hi');
    } else if (type == const Locale('gu')) {
      _appLocale = const Locale('gu');
      await prefs.setString('language_code', 'gu');
    } else if (type == const Locale('kn')) {
      _appLocale = const Locale('kn');
      await prefs.setString('language_code', 'kn');
    } else {
      _appLocale = const Locale('en');
      await prefs.setString('language_code', 'en');
    }
    notifyListeners();
  }
}
