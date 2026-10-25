import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_colors.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/views/common/app_snack_bar.dart';

Widget _buildTestApp({
  required Widget child,
  Brightness brightness = Brightness.light,
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (context, _) => MaterialApp(
      theme: ThemeData(
        brightness: brightness,
        extensions: [
          brightness == Brightness.dark
              ? HabitFlowTokens.dark
              : HabitFlowTokens.light,
        ],
      ),
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('AppSnackBar Widget Tests', () {
    testWidgets(
        'showSuccess displays modern floating pill with green check icon and Urbanist text',
        (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => AppSnackBar.showSuccess(
                  context,
                  message: 'Password changed successfully.',
                ),
                child: const Text('Trigger Success'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Trigger Success'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
      expect(snackBar.shape, isA<StadiumBorder>());
      expect(snackBar.backgroundColor, HabitFlowTokens.light.ink);

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle_rounded));
      expect(icon.color, AppColors.success);

      expect(find.text('Password changed successfully.'), findsOneWidget);
    });

    testWidgets(
        'showError displays modern floating pill with error icon and theme colors',
        (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          brightness: Brightness.dark,
          child: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => AppSnackBar.showError(
                  context,
                  message: 'Current password is incorrect.',
                ),
                child: const Text('Trigger Error'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Trigger Error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
      expect(snackBar.shape, isA<StadiumBorder>());
      expect(snackBar.backgroundColor, HabitFlowTokens.dark.ink);

      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline_rounded));
      expect(icon.color, AppColors.error);

      expect(find.text('Current password is incorrect.'), findsOneWidget);
    });
  });
}
