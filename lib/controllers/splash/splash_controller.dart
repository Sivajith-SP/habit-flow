import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habitflow/repositories/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/config/service_locator.dart';
import '../../app/router/app_routes.dart';
import '../../core/constants/app_constants.dart';

class SplashController {
  SplashController._();

  static Future<void> checkAuth(BuildContext context) async {
    // Keep splash visible briefly
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    final prefs = await SharedPreferences.getInstance();
    if (!context.mounted) return;

    final hasSeenOnboarding =
        prefs.getBool(AppConstants.hasSeenOnboarding) ?? false;

    if (!hasSeenOnboarding) {
      context.go(AppRoutes.onboarding);
      return;
    }

    final authRepository = getIt<AuthRepository>();

    if (authRepository.isLoggedIn) {
      context.go(AppRoutes.dashboard);
    } else {
      context.go(AppRoutes.login);
    }
  }
}
