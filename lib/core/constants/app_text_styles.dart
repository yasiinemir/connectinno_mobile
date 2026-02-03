import 'package:connectionno_mobile/core/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // BNot başlık
  static TextStyle header(BuildContext context) => TextStyle(
    color: AppColors.textPrimary,
    fontSize: context.dynamicWidth(0.05),
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  // Not
  static TextStyle body(BuildContext context) => TextStyle(
    color: AppColors.textSecondary,
    fontSize: context.dynamicWidth(0.035),
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Search bar
  static TextStyle hint(BuildContext context) =>
      TextStyle(color: AppColors.textPrimary, fontSize: context.dynamicWidth(0.04));
}
