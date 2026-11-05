import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/views/privacy/privacy_screen.dart';

Widget _buildWrapper({required Widget child}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (context, _) => MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [HabitFlowTokens.light],
      ),
      home: child,
    ),
  );
}

void main() {
  group('PrivacyScreen UI tests', () {
    testWidgets('renders all privacy sections and tiles correctly',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildWrapper(child: const PrivacyScreen()));
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Data & security'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Hero Card
      expect(find.text('Your privacy matters'), findsOneWidget);
      expect(
        find.text(
            'Here is a simple overview of how HabitFlow handles the information used by the app.'),
        findsOneWidget,
      );

      // Group 1: DATA & STORAGE
      expect(find.text('DATA & STORAGE'), findsOneWidget);
      expect(find.text('Account Information'), findsOneWidget);
      expect(find.text('Habit Data'), findsOneWidget);

      // Group 2: SECURITY & ALERTS
      expect(find.text('SECURITY & ALERTS'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Data Security'), findsOneWidget);

      // Disclaimer (scroll into view if needed)
      final disclaimerFinder = find.textContaining('This information describes');
      await tester.scrollUntilVisible(disclaimerFinder, 200);
      expect(disclaimerFinder, findsOneWidget);
    });

    testWidgets('tapping circular back button pops navigation', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final key = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, _) => MaterialApp(
            navigatorKey: key,
            theme: ThemeData(
              brightness: Brightness.light,
              extensions: [HabitFlowTokens.light],
            ),
            home: const Scaffold(body: Text('Home')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      key.currentState!.push(
        MaterialPageRoute<void>(builder: (_) => const PrivacyScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PrivacyScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(PrivacyScreen), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
