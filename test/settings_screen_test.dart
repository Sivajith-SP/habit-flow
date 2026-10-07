import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/controllers/auth/auth_bloc.dart';
import 'package:habitflow/controllers/theme/theme_cubit.dart';
import 'package:habitflow/repositories/auth/auth_repository.dart';
import 'package:habitflow/views/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  String? get currentUserDisplayName => 'Sivajith';

  @override
  String? get currentUserEmail => 'sivajith.online@gmail.com';

  @override
  String? get currentUserId => 'test-id';

  @override
  bool get isLoggedIn => true;

  @override
  Future<void> changePassword({required String currentPassword, required String newPassword}) async {}

  @override
  Future<void> deleteAccount({required String password}) async {}

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> register({required String email, required String password}) async {}

  @override
  Future<void> updateUserName(String name) async {}
}

Widget _buildSettingsWrapper({
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
        body: child,
      ),
    ),
  );
}

void main() {
  final getIt = GetIt.instance;
  late _FakeAuthRepository fakeRepo;
  late AuthBloc authBloc;
  late ThemeCubit themeCubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fakeRepo = _FakeAuthRepository();
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
    getIt.registerSingleton<AuthRepository>(fakeRepo);

    authBloc = AuthBloc(fakeRepo);
    themeCubit = ThemeCubit();
  });

  tearDown(() {
    authBloc.close();
    themeCubit.close();
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
  });

  group('SettingsScreen Widget Tests', () {
    testWidgets('renders all sections and profile banner on 360px screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<ThemeCubit>.value(value: themeCubit),
          ],
          child: _buildSettingsWrapper(child: const SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Header
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Manage your app preferences'), findsOneWidget);

      // Profile banner
      expect(find.text('Sivajith'), findsOneWidget);
      expect(find.text('sivajith.online@gmail.com'), findsOneWidget);
      expect(find.text('S'), findsOneWidget);

      // Section labels
      expect(find.text('SECURITY'), findsOneWidget);
      expect(find.text('APPEARANCE'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.text('ABOUT'), findsOneWidget);

      // Verify duplicate Profile tile is absent
      expect(find.text('Profile'), findsNothing);

      // Tiles
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Dark mode'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('About HabitFlow'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);

      // Footer App Name & Version
      expect(find.text('HabitFlow'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);

      // Verify Log out button is removed
      expect(find.text('Log out'), findsNothing);
    });

    testWidgets('renders without overflow on narrow 320px screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<ThemeCubit>.value(value: themeCubit),
          ],
          child: _buildSettingsWrapper(
            screenSize: const Size(320, 700),
            child: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders in dark mode without overflow and toggles switch',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<ThemeCubit>.value(value: themeCubit),
          ],
          child: _buildSettingsWrapper(
            brightness: Brightness.dark,
            child: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Find switch and tap it
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
