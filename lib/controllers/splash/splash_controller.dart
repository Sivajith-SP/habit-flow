import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habitflow/repositories/auth/auth_repository.dart';

import '../../app/config/service_locator.dart';
import '../../app/router/app_routes.dart';

class SplashController {
  SplashController._();

  static Future<void> checkAuth(BuildContext context) async {
    // Small delay so the splash is visible
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    final authRepository = getIt<AuthRepository>();

    if (authRepository.isLoggedIn) {
      context.go(AppRoutes.dashboard);
    } else {
      context.go(AppRoutes.login);
    }
  }
}
