import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  AppSpacing._();

  // Base scale
  static double xxs = 2.w;
  static double xs = 4.w;
  static double sm = 8.w;
  static double md = 16.w;
  static double lg = 24.w;
  static double xl = 32.w;
  static double xxl = 48.w;
  static double xxxl = 64.w;

  // Component-level semantic tokens
  static double gap10 = 10.h;         // tagline → title gap
  static double gap12 = 12.h;         // title → subtitle gap
  static double gap14 = 14.h;         // list top padding & tile vertical padding
  static double gap26 = 26.h;         // profile card → list card gap
  static double gap36 = 36.h;         // list card → footer gap
  static double screenPadding = 20.w; // standard screen horizontal padding
  static double dividerIndent = 72.w; // tile content divider indent
  static double buttonHeight = 62.h;  // CTA pill button height
  static double badgeSize = 50.h;     // circular arrow badge diameter
  static double buttonPadding = 6.r;  // inner pill padding
}