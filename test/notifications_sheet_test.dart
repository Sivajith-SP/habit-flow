import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/controllers/notifications/notifications_bloc.dart';
import 'package:habitflow/controllers/notifications/notifications_event.dart';
import 'package:habitflow/core/services/notification_service.dart';
import 'package:habitflow/models/notification/notification_settings.dart';
import 'package:habitflow/repositories/notifications/notification_settings_repository.dart';
import 'package:habitflow/views/notifications/notifications_screen.dart';
import 'package:habitflow/views/notifications/widgets/notifications_main_view.dart';
import 'package:habitflow/views/notifications/widgets/reminder_time_view.dart';

class _FakeNotificationSettingsRepo implements NotificationSettingsRepository {
  NotificationSettings settings = const NotificationSettings(
    notificationsEnabled: true,
    habitRemindersEnabled: true,
    reminderHour: 6,
    reminderMinute: 5,
  );

  @override
  Future<NotificationSettings> getSettings() async => settings;

  @override
  Future<void> saveSettings(NotificationSettings newSettings) async {
    settings = newSettings;
  }
}

class _FakeNotificationService implements NotificationService {
  @override
  Future<void> cancelDailyReminder() async {}

  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {}

  @override
  Future<void> scheduleHabitReminder({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {}

  @override
  Future<void> cancelHabitReminder(int id) async {}

  @override
  Future<void> debugPendingNotifications() async {}

  @override
  Future<void> showTestNotification() async {}
}

Widget _buildWrapper({
  required Widget child,
  required NotificationsBloc bloc,
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (context, _) => MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [HabitFlowTokens.light],
      ),
      home: Scaffold(
        body: BlocProvider<NotificationsBloc>.value(
          value: bloc,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  late _FakeNotificationSettingsRepo repo;
  late _FakeNotificationService service;
  late NotificationsBloc bloc;

  setUp(() {
    repo = _FakeNotificationSettingsRepo();
    service = _FakeNotificationService();
    bloc = NotificationsBloc(repo, service);
    bloc.add(const LoadNotificationSettings());
  });

  tearDown(() {
    bloc.close();
  });

  group('NotificationsSheet in-sheet subview navigation', () {
    testWidgets(
        'tapping Reminder Time navigates to ReminderTimeView and back',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildWrapper(
          child: const NotificationsSheet(),
          bloc: bloc,
        ),
      );
      await tester.pumpAndSettle();

      // Verify main view elements
      expect(find.byType(NotificationsMainView), findsOneWidget);
      expect(find.text('Notifications'), findsWidgets);
      expect(find.text('Habit Reminders'), findsOneWidget);
      expect(find.text('Reminder Time'), findsOneWidget);
      expect(find.text('6:05 AM'), findsOneWidget);
      expect(find.byType(ReminderTimeView), findsNothing);

      // Tap Reminder Time tile to transition in-sheet
      await tester.tap(find.text('Reminder Time'));
      await tester.pumpAndSettle();

      // Verify we are now on ReminderTimeView
      expect(find.byType(ReminderTimeView), findsOneWidget);
      expect(find.text('When should HabitFlow remind you?'), findsOneWidget);
      expect(find.text('Save Time'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Initial drum-roll selection should show 06 and 05 and AM
      expect(find.text('06'), findsNWidgets(2)); // hour 06 and minute 06 (04, 05, 06)
      expect(find.text('05'), findsNWidgets(2)); // hour 05 (05, 06, 07) and minute 05
      expect(find.text('AM'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Verify back on main view
      expect(find.byType(NotificationsMainView), findsOneWidget);
      expect(find.byType(ReminderTimeView), findsNothing);
    });

    testWidgets('saving new time updates state and returns to main view',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildWrapper(
          child: const NotificationsSheet(),
          bloc: bloc,
        ),
      );
      await tester.pumpAndSettle();

      // Open Reminder Time view
      await tester.tap(find.text('Reminder Time'));
      await tester.pumpAndSettle();

      // Tap PM
      await tester.tap(find.text('PM'));
      await tester.pumpAndSettle();

      // Tap Save Time
      await tester.tap(find.text('Save Time'));
      await tester.pump();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();

      // Verify back on main view with updated time (6:05 PM)
      expect(find.byType(NotificationsMainView), findsOneWidget);
      expect(find.text('6:05 PM'), findsOneWidget);
    });
  });
}
