

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier,ThemeMode>((ref)=> ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode>{
  ThemeNotifier():super(ThemeMode.light){
    _loadTheme();
  }

  //Load Saved theme when app starts

  void _loadTheme() async{
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'light';

    if(theme == "dark"){
      state = ThemeMode.dark;
    }else if(theme == "system"){
       state = ThemeMode.system;
    }else{
      state = ThemeMode.light;
    }
  }

  //change + save Theme

  void changeTheme(ThemeMode mode) async{
    state = mode;  // ui change immediately

    final prefs = await SharedPreferences.getInstance();

    if(mode == ThemeMode.dark){
      prefs.setString('theme', 'dark');
    }else if(mode == ThemeMode.system){
      prefs.setString("theme", 'system');
    }else{
      prefs.setString('theme', 'light');
    }
  }
}

