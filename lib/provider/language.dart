import 'package:flutter/material.dart';

class LanguageProv with ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void changeLanguage(String languageCode) {
    _currentLanguage = languageCode;
    print(currentLanguage);
    notifyListeners();
  }
}