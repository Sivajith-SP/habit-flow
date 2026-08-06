import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle heading1 = GoogleFonts.spaceGrotesk(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading2 = GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle title = GoogleFonts.spaceGrotesk(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle body = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodySmall = GoogleFonts.spaceGrotesk(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static final TextStyle button = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle caption = GoogleFonts.spaceGrotesk(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}