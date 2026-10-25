import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habitflow/app/config/service_locator.dart';
import 'package:habitflow/controllers/auth/auth_bloc.dart';
import 'package:habitflow/views/onboarding/onboarding_screen.dart';
import 'package:habitflow/views/shell/app_shell.dart';

import '../../controllers/habits/habits_bloc.dart';
import '../../controllers/habits/habits_event.dart';
import '../../controllers/notifications/notifications_bloc.dart';
import '../../controllers/notifications/notifications_event.dart';
import '../../controllers/statistics/statistics_bloc.dart';
import '../../controllers/statistics/statistics_event.dart';
import '../../views/about/about_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/register_screen.dart';
import '../../views/notifications/notifications_screen.dart';
import '../../views/privacy/privacy_screen.dart';
import '../../views/profile/profile_screen.dart';
import '../../views/security/change_password_screen.dart';
import '../../views/security/delete_account_screen.dart';
import '../../views/security/security_screen.dart';
import '../../views/splash/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider.value(
          value: getIt<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider.value(
          value: getIt<AuthBloc>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<AuthBloc>()),
            BlocProvider(
              create: (_) =>
                  getIt<StatisticsBloc>()..add(const LoadStatistics()),
            ),
          ],
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.security,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          opaque: false,
          barrierDismissible: true,
          barrierColor: Colors.black.withValues(alpha: 0.45),
          child: BlocProvider.value(
            value: getIt<AuthBloc>(),
            child: const SecurityScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => BlocProvider.value(
          value: getIt<AuthBloc>(),
          child: const ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.deleteAccount,
        builder: (context, state) => BlocProvider.value(
          value: getIt<AuthBloc>(),
          child: const DeleteAccountScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              getIt<NotificationsBloc>()..add(const LoadNotificationSettings()),
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<AuthBloc>()),
            BlocProvider(
              create: (_) => getIt<HabitsBloc>()..add(const LoadHabits()),
            ),
            BlocProvider(
              create: (_) =>
                  getIt<StatisticsBloc>()..add(const LoadStatistics()),
            ),
          ],
          child: const AppShell(),
        ),
      ),
    ],
  );
}
