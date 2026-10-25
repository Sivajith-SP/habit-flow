import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:habitflow/app/router/app_routes.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/controllers/auth/auth_bloc.dart';
import 'package:habitflow/controllers/statistics/statistics_bloc.dart';
import 'package:habitflow/models/habit/habit_completion_model.dart';
import 'package:habitflow/models/habit/habit_model.dart';
import 'package:habitflow/repositories/auth/auth_repository.dart';
import 'package:habitflow/repositories/habits/completion_repository.dart';
import 'package:habitflow/repositories/habits/habit_repository.dart';
import 'package:habitflow/views/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements AuthRepository {
  bool didCallLogout = false;

  @override
  String? get currentUserDisplayName => 'Sivajith';

  @override
  String? get currentUserEmail => 'sivajith.online@gmail.com';

  @override
  String? get currentUserId => 'HF-2026-A1B2';

  @override
  bool get isLoggedIn => true;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  @override
  Future<void> deleteAccount({required String password}) async {}

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async {
    didCallLogout = true;
  }

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> updateUserName(String name) async {}
}

class _FakeHabitRepository implements HabitRepository {
  @override
  Future<void> addHabit(HabitModel habit) async {}

  @override
  Future<List<HabitModel>> getHabits() async => [];

  @override
  Future<void> updateHabit(HabitModel habit) async {}

  @override
  Future<void> deleteHabit(String id) async {}

  @override
  Future<void> archiveHabit(String id) async {}

  @override
  Future<HabitModel?> getHabitById(String habitId) async => null;

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

Widget _buildWrapper({
  required Widget child,
  required AuthBloc authBloc,
  required StatisticsBloc statisticsBloc,
  Brightness brightness = Brightness.light,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<StatisticsBloc>.value(value: statisticsBloc),
          ],
          child: child,
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const SizedBox(),
      ),
    ],
  );

  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (context, _) => MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        brightness: brightness,
        extensions: [
          brightness == Brightness.dark
              ? HabitFlowTokens.dark
              : HabitFlowTokens.light,
        ],
      ),
    ),
  );
}

void main() {
  final getIt = GetIt.instance;
  late _FakeAuthRepository fakeRepo;
  late AuthBloc authBloc;
  late StatisticsBloc statisticsBloc;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fakeRepo = _FakeAuthRepository();
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
    getIt.registerSingleton<AuthRepository>(fakeRepo);

    authBloc = AuthBloc(fakeRepo);
    statisticsBloc = StatisticsBloc(
      _FakeCompletionRepository(),
      _FakeHabitRepository(),
    );
  });

  tearDown(() {
    authBloc.close();
    statisticsBloc.close();
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
  });

  group('ProfileScreen Logout Dialog Tests', () {
    testWidgets(
        'renders modern logout dialog with theme styling and cancel dismisses',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildWrapper(
          child: const ProfileScreen(),
          authBloc: authBloc,
          statisticsBloc: statisticsBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the Log out card
      final logoutCard = find.text('Log out');
      expect(logoutCard, findsOneWidget);
      await tester.ensureVisible(logoutCard);
      await tester.pumpAndSettle();
      await tester.tap(logoutCard);
      await tester.pumpAndSettle();

      // Dialog should be presented
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Log out?'), findsOneWidget);
      expect(
        find.text('Are you sure you want to sign out of your HabitFlow account?'),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.logout_rounded),
        findsNWidgets(2), // Card + Dialog badge
      );
      expect(find.text('Cancel'), findsOneWidget);

      // Verify pill dialog container
      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog.shape, isA<RoundedRectangleBorder>());

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog dismissed and logout was not called
      expect(find.byType(Dialog), findsNothing);
      expect(fakeRepo.didCallLogout, isFalse);
    });

    testWidgets('tapping Log out in dialog dispatches LogoutRequested',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildWrapper(
          child: const ProfileScreen(),
          authBloc: authBloc,
          statisticsBloc: statisticsBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Tap Log out card
      final logoutCard = find.text('Log out');
      await tester.ensureVisible(logoutCard);
      await tester.pumpAndSettle();
      await tester.tap(logoutCard);
      await tester.pumpAndSettle();

      // In dialog, find 'Log out' button (which is inside FilledButton)
      final dialogLogoutButton = find.descendant(
        of: find.byType(FilledButton),
        matching: find.text('Log out'),
      );
      expect(dialogLogoutButton, findsOneWidget);

      await tester.tap(dialogLogoutButton);
      await tester.pump();
      await tester.pumpAndSettle();

      // Logout should be triggered on repo
      expect(fakeRepo.didCallLogout, isTrue);
    });
  });
}
