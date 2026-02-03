import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light; 
  }

  // Load saved theme
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme') ?? 'light';

    state = saved == "dark"
        ? ThemeMode.dark
        : saved == "system"
            ? ThemeMode.system
            : ThemeMode.light;
  }

  // Change + Save theme
  void changeTheme(ThemeMode mode) async {
    state = mode;

    final prefs = await SharedPreferences.getInstance();

    final value = mode == ThemeMode.dark
        ? "dark"
        : mode == ThemeMode.system
            ? "system"
            : "light";

    await prefs.setString('theme', value);
  }
}
