import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/views/settings/widgets/member_profile_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Test harness
// ─────────────────────────────────────────────────────────────────────────────

Widget _wrap({
  required Widget child,
  Brightness brightness = Brightness.light,
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (context, childWidget) => MaterialApp(
      theme: ThemeData(
        brightness: brightness,
        extensions: [
          brightness == Brightness.dark
              ? HabitFlowTokens.dark
              : HabitFlowTokens.light,
        ],
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

// Convenience: build a standard card
Widget _card({VoidCallback? onTap}) => MemberProfileCard(
      fullName: 'Sivajith',
      email: 'abc@gmail.com',
      habitflowId: 'HF \u00B7 2026 \u00B7 A1B2',
      onTap: onTap,
    );

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  group('MemberProfileCard', () {
    // 1. Renders all required text elements
    testWidgets('renders name, email and habitflow id', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap(child: _card()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      expect(find.text('Sivajith'), findsOneWidget);
      expect(find.text('abc@gmail.com'), findsOneWidget);
      expect(find.text('HF \u00B7 2026 \u00B7 A1B2'), findsOneWidget);
      expect(find.text('MEMBER PROFILE'), findsOneWidget);
      expect(find.text('HABITFLOW ID'), findsOneWidget);
    });

    // 2. Shows the correct initial letter in the avatar
    testWidgets('shows first letter of name as avatar initial', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap(
        child: MemberProfileCard(
          fullName: 'Priya',
          email: 'priya@test.com',
          habitflowId: 'HF \u00B7 2026 \u00B7 0001',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('P'), findsOneWidget);
    });

    // 3. Falls back to 'H' initial when name is empty
    testWidgets('uses H as fallback initial when name is empty', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap(
        child: MemberProfileCard(
          fullName: '',
          email: 'user@test.com',
          habitflowId: 'HF \u00B7 2026 \u00B7 0000',
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('H'), findsOneWidget);
    });

    // 4. No layout overflow on standard 390px screen
    testWidgets('no overflow on 390px screen', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap(child: _card()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // 5. No layout overflow on narrow 320px screen
    testWidgets('no overflow on narrow 320px screen', (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap(child: _card()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // 6. Renders without overflow in dark mode
    testWidgets('renders without overflow in dark mode', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _wrap(brightness: Brightness.dark, child: _card()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // All text still visible in dark mode
      expect(find.text('Sivajith'), findsOneWidget);
      expect(find.text('HABITFLOW ID'), findsOneWidget);
    });

    // 7. onTap callback fires when card is tapped
    testWidgets('calls onTap when tapped', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      var tapped = false;
      await tester.pumpWidget(
        _wrap(child: _card(onTap: () => tapped = true)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(MemberProfileCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    // 8. Long name and email are clipped, not overflowed
    testWidgets('long name and email do not overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap(
        child: MemberProfileCard(
          fullName: 'Superlongfirstname Superlonglastname',
          email: 'very.long.email.address@subdomain.example.com',
          habitflowId: 'HF \u00B7 2026 \u00B7 ZZZZ',
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
