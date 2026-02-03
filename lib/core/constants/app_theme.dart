import 'package:flutter/material.dart';

class AppTheme {
  // --- AYDINLIK TEMA (Light) ---
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF007AFF),
    scaffoldBackgroundColor: const Color(0xFFF2F2F7), // iOS Gri
    cardColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87), // Başlıklar
      bodyMedium: TextStyle(color: Colors.black87), // İçerik
    ),
    iconTheme: const IconThemeData(color: Colors.black54),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF2F2F7),
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  // --- KARANLIK TEMA (Dark) ---
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0A84FF), // Dark mode mavisi biraz daha parlak olur
    scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30), // Tam siyah (OLED dostu)
    cardColor: const Color.fromARGB(255, 0, 0, 0), // iOS Dark Gri Kart
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Color(0xFFE5E5E5)),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
