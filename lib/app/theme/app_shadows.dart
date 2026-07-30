import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];
}