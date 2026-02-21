import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends Notifier<Locale> {

  @override
  Locale build() {
    loadSavedLanguage();
    return const Locale('en');
  }

  Future<void> changeLanguage(String code) async {
    state = Locale(code);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', code);
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('lang');

    if (code != null) {
      state = Locale(code);
    }
  }
}

final languageProvider =
    NotifierProvider<LanguageNotifier, Locale>(
  LanguageNotifier.new,
);
