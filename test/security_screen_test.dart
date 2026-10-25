import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/app/theme/app_flow_tokens.dart';
import 'package:habitflow/controllers/auth/auth_bloc.dart';
import 'package:habitflow/controllers/auth/auth_event.dart';
import 'package:habitflow/controllers/auth/auth_state.dart';
import 'package:habitflow/repositories/auth/auth_repository.dart';
import 'package:habitflow/views/security/change_password_screen.dart';
import 'package:habitflow/views/security/delete_account_screen.dart';
import 'package:habitflow/views/security/security_screen.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  String? get currentUserDisplayName => 'Test User';

  @override
  String? get currentUserEmail => 'test@example.com';

  @override
  String? get currentUserId => 'test-id';

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
  Future<void> login({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> updateUserName(String name) async {}
}

Widget _buildWrapper({
  required Widget child,
  required AuthBloc authBloc,
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (context, _) => MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [HabitFlowTokens.light],
      ),
      home: Scaffold(
        body: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  late _FakeAuthRepository fakeRepo;
  late AuthBloc authBloc;

  setUp(() {
    fakeRepo = _FakeAuthRepository();
    authBloc = AuthBloc(fakeRepo);
  });

  tearDown(() {
    authBloc.close();
  });

  group('SecurityBottomSheet navigation tests', () {
    testWidgets(
        'tapping Change Password navigates to ChangePasswordView and back',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildWrapper(
          child: const SecurityBottomSheet(),
          authBloc: authBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Main view elements
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Delete Account'), findsOneWidget);
      expect(find.byType(ChangePasswordView), findsNothing);

      // Tap Change Password tile
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      // ChangePasswordView is now visible
      expect(find.byType(ChangePasswordView), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Back to main view
      expect(find.byType(ChangePasswordView), findsNothing);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
    });

    testWidgets('tapping Delete Account navigates to DeleteAccountView and back',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildWrapper(
          child: const SecurityBottomSheet(),
          authBloc: authBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Tap Delete Account tile
      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      // DeleteAccountView is now visible
      expect(find.byType(DeleteAccountView), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Back to main view
      expect(find.byType(DeleteAccountView), findsNothing);
      expect(find.text('Security'), findsOneWidget);
    });

    testWidgets(
        'AuthSuccess displays modern floating pill SnackBar and returns to main view',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildWrapper(
          child: const SecurityBottomSheet(),
          authBloc: authBloc,
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Change Password
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();
      expect(find.byType(ChangePasswordView), findsOneWidget);

      // Trigger password change request and await stream event in real async loop
      await tester.runAsync(() async {
        authBloc.add(
          const ChangePasswordRequested(
            currentPassword: 'currentPassword123',
            newPassword: 'newPassword123',
          ),
        );
        await authBloc.stream.firstWhere((state) => state is AuthSuccess);
      });

      // Pump frame for BlocListener & SnackBar presentation animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Floating pill SnackBar is displayed
      expect(find.byType(SnackBar), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
      expect(snackBar.shape, isA<StadiumBorder>());
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.text('Password changed successfully.'), findsOneWidget);

      // Sheet transitioned back to main view
      expect(find.byType(ChangePasswordView), findsNothing);
      expect(find.text('Security'), findsOneWidget);
    });
  });
}
