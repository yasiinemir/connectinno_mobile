import 'package:flutter/material.dart';

extension ScreenUtils on BuildContext {
  // Ekran Genişliği
  double get width => MediaQuery.of(this).size.width;

  // Ekran Yüksekliği
  double get height => MediaQuery.of(this).size.height;

  // Dinamik yükseklik
  double dynamicHeight(double val) => height * val;

  // Dinamik genişlik
  double dynamicWidth(double val) => width * val;
}
