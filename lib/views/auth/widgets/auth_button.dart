import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_durations.dart';
import '../../../app/theme/app_radius.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: FilledButton(
        onPressed: _isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: .45),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: AnimatedSwitcher(
          duration: AppDurations.fast,
          child: isLoading
              ? SizedBox(
                  key: const ValueKey('loading'),
                  width: 22.w,
                  height: 22.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(
                  text,
                  key: const ValueKey('text'),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: .3,
                  ),
                ),
        ),
      ),
    );
  }
}