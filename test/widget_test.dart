import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/views/statistics/widgets/monthly_progress_card.dart';
import 'package:habitflow/views/statistics/widgets/statistics_overview_card.dart';
import 'package:habitflow/views/statistics/widgets/streak_card.dart';

Widget _buildTestWrapper({
  required Widget child,
  Brightness brightness = Brightness.light,
  Size screenSize = const Size(360, 800),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('Statistics Widgets Responsiveness Tests', () {
    testWidgets('MonthlyProgressCard renders without overflow on 320px narrow screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildTestWrapper(
          screenSize: const Size(320, 700),
          child: const MonthlyProgressCard(
            monthlyCompleted: 42,
            monthlyTotal: 50,
            currentStreak: 7,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('MONTHLY CONSISTENCY'), findsOneWidget);
      expect(find.text('7d streak'), findsOneWidget);
      expect(find.text('84%'), findsOneWidget);
    });

    testWidgets('StatisticsOverviewCard renders without overflow on 320px narrow screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildTestWrapper(
          screenSize: const Size(320, 700),
          child: const StatisticsOverviewCard(
            completedToday: 5,
            totalHabits: 7,
            currentStreak: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text("Today's Rate"), findsOneWidget);
      expect(find.text('71%'), findsOneWidget);
      expect(find.text('Done Today'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('StreakCard renders without overflow on 320px narrow screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildTestWrapper(
          screenSize: const Size(320, 700),
          child: const StreakCard(currentStreak: 14),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Current Streak'), findsOneWidget);
      expect(find.text('14 Days'), findsOneWidget);
    });

    testWidgets('Statistics widgets render in dark mode without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildTestWrapper(
          brightness: Brightness.dark,
          child: const Column(
            children: [
              MonthlyProgressCard(
                monthlyCompleted: 15,
                monthlyTotal: 20,
                currentStreak: 5,
              ),
              SizedBox(height: 16),
              StatisticsOverviewCard(
                completedToday: 3,
                totalHabits: 4,
                currentStreak: 5,
              ),
              SizedBox(height: 16),
              StreakCard(currentStreak: 5),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('75%'), findsOneWidget);
      expect(find.text("Today's Rate"), findsOneWidget);
      expect(find.text('Done Today'), findsOneWidget);
    });
  });
}
