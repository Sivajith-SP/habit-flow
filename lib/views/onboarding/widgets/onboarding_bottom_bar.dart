import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_curves.dart';
import '../../../app/theme/app_durations.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class OnboardingBottomBar extends StatefulWidget {
  final bool isLastPage;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const OnboardingBottomBar({
    super.key,
    required this.isLastPage,
    required this.onSkip,
    required this.onNext,
  });

  @override
  State<OnboardingBottomBar> createState() => _OnboardingBottomBarState();
}

class _OnboardingBottomBarState extends State<OnboardingBottomBar> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final darkGreen = AppColors.primaryDark;
    final circleBg = AppColors.accentCream;
    final arrowColor = AppColors.primaryDark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.lightImpact();
        widget.onNext();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        child: Container(
          height: AppSpacing.buttonHeight,
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.buttonPadding),
          decoration: BoxDecoration(
            color: darkGreen,
            borderRadius: BorderRadius.circular(AppRadius.pill.r),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Centered CTA Text with clean, natural cross-fade + scale micro-animation
              Positioned.fill(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: AppDurations.xFast,
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      widget.isLastPage ? "Get started" : "Next",
                      key: ValueKey<bool>(widget.isLastPage),
                      style: (Theme.of(context).textTheme.labelLarge ?? AppTextStyles.button).copyWith(
                        fontSize: AppTextStyles.title.fontSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              // Trailing circular badge:
              // - On "Next": Arrow is STRAIGHT (→)
              // - On "Get started": Arrow TILTS up-right (↗)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: AppSpacing.badgeSize,
                  height: AppSpacing.badgeSize,
                  decoration: BoxDecoration(
                    color: circleBg,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedRotation(
                    turns: widget.isLastPage ? -0.125 : 0.0,
                    duration: AppDurations.medium,
                    curve: AppCurves.emphasized,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: arrowColor,
                      size: AppSpacing.md,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}