import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class HabitFlowTokens extends ThemeExtension<HabitFlowTokens> {
  // Colors
  final Color background;
  final Color surface;
  final Color raised;
  final Color text;
  final Color mutedText;
  final Color accent;
  final Color onAccent;
  final Color border;

  // Tile backgrounds and icon tints
  final Color tileLavender;
  final Color tileLavenderIcon;
  final Color tileMint;
  final Color tileMintIcon;
  final Color tileButter;
  final Color tileButterIcon;
  final Color tilePink;
  final Color tilePinkIcon;

  // Center Plus Button
  final Color centerPlusBg;
  final Color centerPlusIcon;

  // Depth tokens
  final List<BoxShadow> cardShadow;
  final BoxBorder cardBorder;

  const HabitFlowTokens({
    required this.background,
    required this.surface,
    required this.raised,
    required this.text,
    required this.mutedText,
    required this.accent,
    required this.onAccent,
    required this.border,
    required this.tileLavender,
    required this.tileLavenderIcon,
    required this.tileMint,
    required this.tileMintIcon,
    required this.tileButter,
    required this.tileButterIcon,
    required this.tilePink,
    required this.tilePinkIcon,
    required this.centerPlusBg,
    required this.centerPlusIcon,
    required this.cardShadow,
    required this.cardBorder,
  });

  // Light Theme Tokens
  static final HabitFlowTokens light = HabitFlowTokens(
    background: const Color(0xFFF6F4FB),
    surface: const Color(0xFFFFFFFF),
    raised: const Color(0xFFFFFFFF),
    text: const Color(0xFF16182B),
    mutedText: const Color(0xFF7A7890),
    accent: const Color(0xFF8B6FE0),
    onAccent: const Color(0xFFFFFFFF),
    border: Colors.transparent,
    tileLavender: const Color(0xFFDCD3F8),
    tileLavenderIcon: const Color(0xFF5B43B5),
    tileMint: const Color(0xFFD8EBE3),
    tileMintIcon: const Color(0xFF2E7D66),
    tileButter: const Color(0xFFF7E8B9),
    tileButterIcon: const Color(0xFF9A7410),
    tilePink: const Color(0xFFF9D4EA),
    tilePinkIcon: const Color(0xFFB5478A),
    centerPlusBg: const Color(0xFF16182B),
    centerPlusIcon: const Color(0xFFFFFFFF),
    cardShadow: const [
      BoxShadow(
        color: Color(0x145B43B5), // purple-tinted, 8% opacity
        blurRadius: 24,
        offset: Offset(0, 6),
      ),
    ],
    cardBorder: Border.all(color: Colors.transparent, width: 0),
  );

  // Dark Theme Tokens
  static final HabitFlowTokens dark = HabitFlowTokens(
    background: const Color(0xFF12111A),
    surface: const Color(0xFF1C1A28),
    raised: const Color(0xFF262336),
    text: const Color(0xFFF3F1FA),
    mutedText: const Color(0xFFA29FB8),
    accent: const Color(0xFFA48CF0),
    onAccent: const Color(0xFF12111A),
    border: const Color(0xFF2E2B40),
    tileLavender: const Color(0xFF38305F),
    tileLavenderIcon: const Color(0xFFB7A5F5),
    tileMint: const Color(0xFF1F3A33),
    tileMintIcon: const Color(0xFF7FD1B5),
    tileButter: const Color(0xFF4A3F1E),
    tileButterIcon: const Color(0xFFE3C25E),
    tilePink: const Color(0xFF4A2A3D),
    tilePinkIcon: const Color(0xFFF09AC8),
    centerPlusBg: const Color(0xFFF3F1FA),
    centerPlusIcon: const Color(0xFF16182B),
    cardShadow: const [],
    cardBorder: Border.all(color: const Color(0xFF2E2B40), width: 1),
  );

  @override
  HabitFlowTokens copyWith({
    Color? background,
    Color? surface,
    Color? raised,
    Color? text,
    Color? mutedText,
    Color? accent,
    Color? onAccent,
    Color? border,
    Color? tileLavender,
    Color? tileLavenderIcon,
    Color? tileMint,
    Color? tileMintIcon,
    Color? tileButter,
    Color? tileButterIcon,
    Color? tilePink,
    Color? tilePinkIcon,
    Color? centerPlusBg,
    Color? centerPlusIcon,
    List<BoxShadow>? cardShadow,
    BoxBorder? cardBorder,
  }) {
    return HabitFlowTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      raised: raised ?? this.raised,
      text: text ?? this.text,
      mutedText: mutedText ?? this.mutedText,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      border: border ?? this.border,
      tileLavender: tileLavender ?? this.tileLavender,
      tileLavenderIcon: tileLavenderIcon ?? this.tileLavenderIcon,
      tileMint: tileMint ?? this.tileMint,
      tileMintIcon: tileMintIcon ?? this.tileMintIcon,
      tileButter: tileButter ?? this.tileButter,
      tileButterIcon: tileButterIcon ?? this.tileButterIcon,
      tilePink: tilePink ?? this.tilePink,
      tilePinkIcon: tilePinkIcon ?? this.tilePinkIcon,
      centerPlusBg: centerPlusBg ?? this.centerPlusBg,
      centerPlusIcon: centerPlusIcon ?? this.centerPlusIcon,
      cardShadow: cardShadow ?? this.cardShadow,
      cardBorder: cardBorder ?? this.cardBorder,
    );
  }

  @override
  HabitFlowTokens lerp(ThemeExtension<HabitFlowTokens>? other, double t) {
    if (other is! HabitFlowTokens) return this;
    return HabitFlowTokens(
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      raised: Color.lerp(raised, other.raised, t) ?? raised,
      text: Color.lerp(text, other.text, t) ?? text,
      mutedText: Color.lerp(mutedText, other.mutedText, t) ?? mutedText,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      onAccent: Color.lerp(onAccent, other.onAccent, t) ?? onAccent,
      border: Color.lerp(border, other.border, t) ?? border,
      tileLavender: Color.lerp(tileLavender, other.tileLavender, t) ?? tileLavender,
      tileLavenderIcon: Color.lerp(tileLavenderIcon, other.tileLavenderIcon, t) ?? tileLavenderIcon,
      tileMint: Color.lerp(tileMint, other.tileMint, t) ?? tileMint,
      tileMintIcon: Color.lerp(tileMintIcon, other.tileMintIcon, t) ?? tileMintIcon,
      tileButter: Color.lerp(tileButter, other.tileButter, t) ?? tileButter,
      tileButterIcon: Color.lerp(tileButterIcon, other.tileButterIcon, t) ?? tileButterIcon,
      tilePink: Color.lerp(tilePink, other.tilePink, t) ?? tilePink,
      tilePinkIcon: Color.lerp(tilePinkIcon, other.tilePinkIcon, t) ?? tilePinkIcon,
      centerPlusBg: Color.lerp(centerPlusBg, other.centerPlusBg, t) ?? centerPlusBg,
      centerPlusIcon: Color.lerp(centerPlusIcon, other.centerPlusIcon, t) ?? centerPlusIcon,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      cardBorder: t < 0.5 ? cardBorder : other.cardBorder,
    );
  }

  // Convenient design token accessors
  Color get field => this == HabitFlowTokens.dark
      ? const Color(0xFF262336)
      : const Color(0xFFF3F0FA);
  Color get ink => centerPlusBg;
  Color get onInk => centerPlusIcon;
  Color get hairline => border == Colors.transparent
      ? const Color(0xFFE2DEEE)
      : border;
  Color get chipOverlay =>
      surface.withValues(alpha: this == HabitFlowTokens.dark ? 0.20 : 0.65);
}

/// Extension on [BuildContext] to easily access the [HabitFlowTokens].
extension HabitFlowTokensExtension on BuildContext {
  HabitFlowTokens get flowTokens {
    final extension = Theme.of(this).extension<HabitFlowTokens>();
    if (extension != null) return extension;
    return Theme.of(this).brightness == Brightness.dark
        ? HabitFlowTokens.dark
        : HabitFlowTokens.light;
  }
}

/// Typography helper using Urbanist (weights 400, 500, 600, 700, 800).
class AppUrbanist {
  AppUrbanist._();

  /// Greeting: 38px / 800 / letter-spacing -2%
  static TextStyle greeting({required Color color}) => GoogleFonts.urbanist(
        fontSize: 38.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * 38.sp,
        height: 1.12,
        color: color,
      );

  /// Section title: 20px / 700
  static TextStyle sectionTitle({required Color color}) => GoogleFonts.urbanist(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      );

  /// Habit name: 17px / 700
  static TextStyle habitName({required Color color, TextDecoration? decoration}) =>
      GoogleFonts.urbanist(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
        decoration: decoration,
      );

  /// Body and meta: 14-15px / 500
  static TextStyle body({required Color color, double? fontSize, FontWeight? fontWeight}) =>
      GoogleFonts.urbanist(
        fontSize: fontSize ?? 14.sp,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.3,
        color: color,
      );

  /// Large stat numbers: 34px / 800
  static TextStyle statNumber({required Color color}) => GoogleFonts.urbanist(
        fontSize: 34.sp,
        fontWeight: FontWeight.w800,
        height: 1.0,
        color: color,
      );

  /// Percentage ring number: 26px / 800
  static TextStyle percentage({required Color color}) => GoogleFonts.urbanist(
        fontSize: 26.sp,
        fontWeight: FontWeight.w800,
        height: 1.1,
        color: color,
      );

  /// Bottom sheet header title: 26px / 800 / letter-spacing -0.5
  static TextStyle sheetTitle({required Color color}) => GoogleFonts.urbanist(
        fontSize: 26.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.15,
        color: color,
      );

  /// Bento cell label: 13px / 700
  static TextStyle tileLabel({required Color color}) => GoogleFonts.urbanist(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      );

  /// Large habit name input: 24px / 800 / letter-spacing -0.5
  static TextStyle habitInputTitle({required Color color}) => GoogleFonts.urbanist(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.2,
        color: color,
      );

  /// Habit note input: 15px / 500
  static TextStyle habitInputNote({required Color color}) => GoogleFonts.urbanist(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: color,
      );

  /// Repeat pill buttons: 14px / 700
  static TextStyle pillButton({required Color color}) => GoogleFonts.urbanist(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      );

  /// Day circle label: 13px / 700
  static TextStyle dayCircle({required Color color}) => GoogleFonts.urbanist(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      );

  /// Days count caption: 12px / 600
  static TextStyle daysCaption({required Color color}) => GoogleFonts.urbanist(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      );

  /// Save habit button: 17px / 800
  static TextStyle saveButton({required Color color}) => GoogleFonts.urbanist(
        fontSize: 17.sp,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: color,
      );

  /// Pill SnackBar text: 15px / 700
  static TextStyle snackBar({required Color color}) => GoogleFonts.urbanist(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      );
}
