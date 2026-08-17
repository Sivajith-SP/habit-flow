import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette (Forest & Sage Greens matching design image)
  static const Color primary = Color(0xFF425E3B);
  static const Color primaryDark = Color(0xFF2E4327);
  static const Color primaryLight = Color(0xFFC4D5BD);
  static const Color accentCream = Color(0xFFEBE5C9);

  // Mesh Background & Top-Left Glow Tokens
  static const Color meshTopLeftGlow = Color(
    0xFFF9F5CB,
  ); // Warm vibrant sunlit yellow/cream glow
  static const Color meshMintAccent = Color(
    0xFFAFD6A3,
  ); // Vibrant soft emerald/mint accent
  static const Color meshWarmGlow = Color(
    0xFFEFE8B8,
  ); // Subtle warm accent blob
  static const Color meshBaseStart = Color(
    0xFFE5EFE2,
  ); // Base gradient top-left
  static const Color meshBaseEnd = Color(
    0xFFEBE5D3,
  ); // Base gradient bottom-right

  // Background Canvas
  static const Color background = Color(0xFFF5F5F7);
  static const Color card = Colors.white;

  // Text Colors (High Contrast Natural Tones)
  static const Color textPrimary = Color(0xFF1E2E1B);
  static const Color textSecondary = Color(0xFF4A5C44);
  static const Color textMuted = Color(0xFF6B7B63);

  // Status
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF1E88E5);

  // Border & Divider
  static const Color border = Color(0xFFC0C9BC);
  static const Color divider = Color(0xFFDAE2D7);

  // Basics
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // State Overlays & Shadows
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color overlay = Color(0x33000000);
  static const Color shadow = Color(0x14000000);
}
