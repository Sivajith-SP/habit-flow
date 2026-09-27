import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/controllers/habits/habits_state.dart';
import 'package:habitflow/views/dashboard/widgets/main_progress_card.dart';

void main() {
  testWidgets(
      'MainProgressCard renders without overflow on 360px small screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final notifier = ValueNotifier<DateTime>(
      DateTime(2026, 9, 20),
    );

    // Build a realistic HabitsLoaded state
    const state = HabitsLoaded(
      habits: [],
      completedToday: 3,
      totalHabits: 4,
      weekProgress: [true, true, false, true, false, false, true],
      currentStreak: 1,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: ThemeData(
            extensions: [HabitFlowTokens.light],
          ),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MainProgressCard(
                habitsState: state,
                selectedDayNotifier: notifier,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // Header
    expect(find.text("Today's progress"), findsOneWidget);

    // Streak pill
    expect(find.text('1 day streak'), findsOneWidget);

    // "habits done" label
    expect(find.text('habits done'), findsOneWidget);

    notifier.dispose();
  });

  testWidgets('StreakPill shows "Start a streak" when streak is 0',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final notifier = ValueNotifier<DateTime>(DateTime(2026, 9, 20));

    const state = HabitsLoaded(
      habits: [],
      completedToday: 0,
      totalHabits: 4,
      weekProgress: [false, false, false, false, false, false, false],
      currentStreak: 0,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: ThemeData(extensions: [HabitFlowTokens.light]),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MainProgressCard(
                habitsState: state,
                selectedDayNotifier: notifier,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Start a streak'), findsOneWidget);

    notifier.dispose();
  });

  testWidgets(
      'MainProgressCard renders in dark theme without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final notifier = ValueNotifier<DateTime>(DateTime(2026, 9, 20));

    const state = HabitsLoaded(
      habits: [],
      completedToday: 4,
      totalHabits: 4,
      weekProgress: [true, true, true, true, true, true, true],
      currentStreak: 7,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: ThemeData(
            brightness: Brightness.dark,
            extensions: [HabitFlowTokens.dark],
          ),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MainProgressCard(
                habitsState: state,
                selectedDayNotifier: notifier,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('7 day streak'), findsOneWidget);
    expect(find.text('Perfect day'), findsOneWidget);

    notifier.dispose();
  });
}
