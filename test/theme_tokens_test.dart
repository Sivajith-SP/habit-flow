import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';

void main() {
  group('HabitFlowTokens Tests', () {
    test('Light and Dark tokens have correct colors', () {
      final light = HabitFlowTokens.light;
      final dark = HabitFlowTokens.dark;

      // Background
      expect(light.background, const Color(0xFFF6F4FB));
      expect(dark.background, const Color(0xFF12111A));

      // Surface
      expect(light.surface, const Color(0xFFFFFFFF));
      expect(dark.surface, const Color(0xFF1C1A28));

      // Raised
      expect(light.raised, const Color(0xFFFFFFFF));
      expect(dark.raised, const Color(0xFF262336));

      // Accent
      expect(light.accent, const Color(0xFF8B6FE0));
      expect(dark.accent, const Color(0xFFA48CF0));

      // Tiles
      expect(light.tileLavender, const Color(0xFFDCD3F8));
      expect(light.tileMint, const Color(0xFFD8EBE3));
      expect(light.tileButter, const Color(0xFFF7E8B9));
      expect(light.tilePink, const Color(0xFFF9D4EA));

      expect(dark.tileLavender, const Color(0xFF38305F));
      expect(dark.tileMint, const Color(0xFF1F3A33));
      expect(dark.tileButter, const Color(0xFF4A3F1E));
      expect(dark.tilePink, const Color(0xFF4A2A3D));

      // Depth
      expect(light.cardShadow.isNotEmpty, isTrue);
      expect(dark.cardShadow.isEmpty, isTrue);
    });

    test('HabitFlowTokens lerp works properly', () {
      final light = HabitFlowTokens.light;
      final dark = HabitFlowTokens.dark;

      final mid = light.lerp(dark, 0.5);
      expect(mid.background, isNotNull);
      expect(mid.surface, isNotNull);
    });
  });
}
