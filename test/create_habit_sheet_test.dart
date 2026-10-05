import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/controllers/habits/habits_bloc.dart';
import 'package:habitflow/models/habit/habit_completion_model.dart';
import 'package:habitflow/models/habit/habit_frequency.dart';
import 'package:habitflow/models/habit/habit_model.dart';
import 'package:habitflow/repositories/habits/completion_repository.dart';
import 'package:habitflow/repositories/habits/habit_repository.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/bento_cell.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/create_habit_sheet.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/days_cell.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/icon_cell.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/name_cell.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/repeat_cell.dart';
import 'package:habitflow/views/dashboard/widgets/create_habit/save_habit_button.dart';

class _FakeHabitRepository implements HabitRepository {
  final List<HabitModel> habits = [];

  @override
  Future<List<HabitModel>> getHabits() async => habits;

  @override
  Future<void> addHabit(HabitModel habit) async => habits.add(habit);

  @override
  Future<void> updateHabit(HabitModel habit) async {
    final idx = habits.indexWhere((h) => h.id == habit.id);
    if (idx != -1) habits[idx] = habit;
  }

  @override
  Future<void> deleteHabit(String id) async => habits.removeWhere((h) => h.id == id);

  @override
  Future<void> archiveHabit(String id) async {}

  @override
  Future<void> unarchiveHabit(String id) async {}

  @override
  Future<List<HabitModel>> getArchivedHabits() async => [];

  @override
  Future<HabitModel?> getHabitById(String habitId) async {
    return habits.where((h) => h.id == habitId).firstOrNull;
  }

  @override
  Future<int> getMonthlyScheduledCount() async => 0;

  @override
  Future<void> restoreHabit(String habitId) async {}
}

class _FakeCompletionRepository implements CompletionRepository {
  @override
  Future<void> toggleCompletion({required String habitId, required DateTime date}) async {}

  @override
  Future<bool> isCompleted({required String habitId, required DateTime date}) async => false;

  @override
  Future<List<HabitCompletionModel>> getCompletions(String habitId) async => [];

  @override
  Future<List<bool>> getCurrentWeekProgress() async => List.filled(7, false);

  @override
  Future<List<int>> getCurrentWeekDailyCompletions() async => List.filled(7, 0);

  @override
  Future<List<int>> getCurrentWeekDailyTotals() async => List.filled(7, 0);

  @override
  Future<int> getCurrentStreak() async => 0;

  @override
  Future<int> getMonthlyCompleted() async => 0;
}

Widget _wrapSheet(Widget child, HabitsBloc bloc, {double width = 360}) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      theme: ThemeData(
        extensions: [HabitFlowTokens.light],
      ),
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 800)),
        child: Scaffold(
          body: BlocProvider.value(
            value: bloc,
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  late _FakeHabitRepository habitRepository;
  late _FakeCompletionRepository completionRepository;
  late HabitsBloc bloc;

  setUp(() {
    habitRepository = _FakeHabitRepository();
    completionRepository = _FakeCompletionRepository();
    bloc = HabitsBloc(habitRepository, completionRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('CreateHabitSheet Widget Tests', () {
    testWidgets('renders all bento cells without overflow at 360px', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc, width: 360));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('New habit'), findsOneWidget);
      expect(find.byType(BentoCell), findsNWidgets(4)); // Name, Icon, Repeat, Days
      expect(find.byType(NameCell), findsOneWidget);
      expect(find.byType(IconCell), findsOneWidget);
      expect(find.byType(RepeatCell), findsOneWidget);
      expect(find.byType(DaysCell), findsOneWidget);
      expect(find.byType(SaveHabitButton), findsOneWidget);
      expect(find.text('Save habit'), findsOneWidget);
    });

    testWidgets('renders without overflow on narrow 320px device width', (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc, width: 320));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(DaysCell), findsOneWidget);
    });

    testWidgets('Save button is disabled when title is empty', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      final saveButton = tester.widget<SaveHabitButton>(find.byType(SaveHabitButton));
      expect(saveButton.isEnabled, isFalse);
    });

    testWidgets('Entering habit name enables Save button when Daily', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Drink water');
      await tester.pumpAndSettle();

      final saveButton = tester.widget<SaveHabitButton>(find.byType(SaveHabitButton));
      expect(saveButton.isEnabled, isTrue);
    });

    testWidgets(
        'Daily: all 7 days selected, Days tile disabled/dimmed, caption "Every day"',
        (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      // Default is Daily — caption should be "Every day"
      expect(find.text('Every day'), findsOneWidget);

      // DaysCell should be in dimmed, pointer-ignoring state
      final daysCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(daysCell.isDaily, isTrue);
      expect(daysCell.selectedDays, equals({1, 2, 3, 4, 5, 6, 7}));
    });

    testWidgets('Weekly: caption is "Once a week"', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Weekly'));
      await tester.pumpAndSettle();

      expect(find.text('Once a week'), findsOneWidget);

      final daysCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(daysCell.isDaily, isFalse);
      expect(daysCell.selectedDays.length, 1);
    });

    testWidgets('Weekly: tapping a day replaces selection (single-select)', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Weekly'));
      await tester.pumpAndSettle();

      // Tapping a different day replaces the selection
      await tester.tap(find.text('W').first); // Wednesday circle
      await tester.pumpAndSettle();

      final daysCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(daysCell.selectedDays.length, 1);
      // Caption should still be "Once a week"
      expect(find.text('Once a week'), findsOneWidget);
    });

    testWidgets('Custom: caption is "{n} selected"', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      final daysCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(daysCell.isDaily, isFalse);
      // Caption shows count
      expect(find.text('${daysCell.selectedDays.length} selected'), findsOneWidget);
    });

    testWidgets(
        'Custom with all 7 days selected: caption shows "Every day"',
        (tester) async {
      // Seed a Custom habit with all 7 days already selected
      final now = DateTime.now();
      final habit = HabitModel(
        id: 'test-1',
        title: 'All days',
        description: '',
        iconCodePoint: Icons.water_drop_outlined.codePoint,
        colorValue: 0,
        frequency: HabitFrequency.custom,
        targetDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(_wrapSheet(CreateHabitSheet(habit: habit), bloc));
      await tester.pumpAndSettle();

      final daysCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(daysCell.selectedDays.length, 7);
      // When all 7 selected in Custom, caption should be "Every day"
      expect(find.text('Every day'), findsOneWidget);
    });

    testWidgets('Transition: Daily to Weekly preselects today weekday', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Weekly'));
      await tester.pumpAndSettle();

      final daysCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(daysCell.selectedDays.length, 1);
      expect(daysCell.selectedDays.first, DateTime.now().weekday);
    });

    testWidgets('Transition: Daily to Custom preselects today weekday', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      final daysCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(daysCell.selectedDays.length, 1);
      expect(daysCell.selectedDays.first, DateTime.now().weekday);
    });

    testWidgets('Transition: Weekly to Custom keeps selected day', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Weekly'));
      await tester.pumpAndSettle();

      final weeklyCell = tester.widget<DaysCell>(find.byType(DaysCell));
      final selectedBeforeSwitch = Set<int>.from(weeklyCell.selectedDays);

      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      final customCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(customCell.selectedDays, equals(selectedBeforeSwitch));
    });

    testWidgets('Transition: Custom to Weekly keeps earliest selected day', (tester) async {
      // Start from a Custom habit with days {3, 5} (Wed, Fri) — Mon=1 is earliest
      final now = DateTime.now();
      final habit = HabitModel(
        id: 'test-2',
        title: 'Custom habit',
        description: '',
        iconCodePoint: Icons.water_drop_outlined.codePoint,
        colorValue: 0,
        frequency: HabitFrequency.custom,
        targetDays: const [1, 3, 5], // Mon, Wed, Fri
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(_wrapSheet(CreateHabitSheet(habit: habit), bloc));
      await tester.pumpAndSettle();

      // Verify it opens in Custom with 3 days
      final customCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(customCell.selectedDays, containsAll([1, 3, 5]));

      // Switch to Weekly — should keep earliest day (1 = Monday)
      await tester.tap(find.text('Weekly'));
      await tester.pumpAndSettle();

      final weeklyCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(weeklyCell.selectedDays, equals({1}));
    });

    testWidgets('Transition: Weekly/Custom to Daily selects all 7 days', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Weekly'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      final daysCell = tester.widget<DaysCell>(find.byType(DaysCell));
      expect(daysCell.selectedDays, equals({1, 2, 3, 4, 5, 6, 7}));
      expect(daysCell.isDaily, isTrue);
      expect(find.text('Every day'), findsOneWidget);
    });

    testWidgets('Save disabled when Custom has no days selected', (tester) async {
      // Seed an existing Custom habit with no targetDays to test the save-disabled state
      final now = DateTime.now();
      final habit = HabitModel(
        id: 'test-3',
        title: 'No days habit',
        description: '',
        iconCodePoint: Icons.water_drop_outlined.codePoint,
        colorValue: 0,
        frequency: HabitFrequency.custom,
        targetDays: const [], // no days selected
        createdAt: now,
        updatedAt: now,
      );
      await tester.pumpWidget(_wrapSheet(CreateHabitSheet(habit: habit), bloc));
      await tester.pumpAndSettle();

      // Name is pre-filled; Custom frequency with 0 days → Save must be disabled
      final saveButton = tester.widget<SaveHabitButton>(find.byType(SaveHabitButton));
      expect(saveButton.isEnabled, isFalse);
    });

    testWidgets('Submitting creates habit and adds AddHabit event', (tester) async {
      await tester.pumpWidget(_wrapSheet(const CreateHabitSheet(), bloc));
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(find.byType(TextField).first, 'Morning Jog');
      await tester.pumpAndSettle();

      // Ensure visible and tap save
      await tester.ensureVisible(find.byType(SaveHabitButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SaveHabitButton));
      await tester.pumpAndSettle();

      expect(habitRepository.habits.length, 1);
      expect(habitRepository.habits.first.title, 'Morning Jog');
      expect(habitRepository.habits.first.colorValue, 0); // Mint
      expect(habitRepository.habits.first.frequency, HabitFrequency.daily);
    });
  });
}
