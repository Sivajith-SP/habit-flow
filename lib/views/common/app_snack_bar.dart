import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_flow_tokens.dart';

/// Centralized, design-system-aligned floating pill SnackBar for HabitFlow.
class AppSnackBar {
  AppSnackBar._();

  /// Shows a modern floating pill SnackBar for successful actions.
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(milliseconds: 2800),
  }) {
    _showPill(
      context: context,
      message: message,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
      duration: duration,
    );
  }

  /// Shows a modern floating pill SnackBar for error or failure events.
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    _showPill(
      context: context,
      message: message,
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      duration: duration,
    );
  }

  /// Shows a modern floating pill SnackBar for informative notices.
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(milliseconds: 2800),
  }) {
    final tokens = context.flowTokens;
    _showPill(
      context: context,
      message: message,
      icon: Icons.info_outline_rounded,
      iconColor: tokens.accent,
      duration: duration,
    );
  }

  static void _showPill({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color iconColor,
    required Duration duration,
  }) {
    final tokens = context.flowTokens;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: tokens.ink,
          elevation: 6,
          shape: const StadiumBorder(),
          margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          duration: duration,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  message,
                  style: AppUrbanist.snackBar(color: tokens.onInk),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
