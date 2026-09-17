import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey);

    switch (savedTheme) {
      case 'light':
        emit(ThemeMode.light);
        break;

      case 'dark':
        emit(ThemeMode.dark);
        break;

      default:
        emit(ThemeMode.system);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _themeKey,
      mode.name,
    );
  }
}