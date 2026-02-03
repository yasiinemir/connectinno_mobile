import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  // Temayı Değiştir ve Kaydet
  void toggleTheme(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(mode);
    _saveTheme(isDark);
  }

  // Hafızadan Oku
  void _loadTheme() async {
    var box = await Hive.openBox('settings');
    bool? isDark = box.get('isDark');
    if (isDark != null) {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }

  // Hafızaya Yaz
  void _saveTheme(bool isDark) async {
    var box = await Hive.openBox('settings');
    box.put('isDark', isDark);
  }
}
