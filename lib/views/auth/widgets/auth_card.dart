import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_spacing.dart';

/// Deep-frosted glass card with crisp contrast shadows.
class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),

            // High-contrast frosted glass body
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: .90),
                Colors.white.withValues(alpha: .72),
              ],
            ),

            boxShadow: [
              // Primary drop shadow for depth
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 36,
                spreadRadius: -4,
                offset: const Offset(0, 14),
              ),
              // Subtle primary ambient glow
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: .08),
                blurRadius: 48,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
              // Crisp deep shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 64,
                spreadRadius: -2,
                offset: const Offset(0, 24),
              ),
            ],
          ),

          child: child,
        ),
      ),
    );
  }
}
