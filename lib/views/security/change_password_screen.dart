import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_event.dart';
import '../../controllers/auth/auth_state.dart';
import '../common/app_snack_bar.dart';

// =============================================================================
// Standalone Change Password Screen
// =============================================================================

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          AppSnackBar.showSuccess(
            context,
            message: 'Password changed successfully.',
          );
          Navigator.maybePop(context);
        }
      },
      child: Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 36.h),
            child: ChangePasswordView(
              onBack: () => Navigator.maybePop(context),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Reusable Change Password View (Used in bottom sheet & standalone screen)
// =============================================================================

class ChangePasswordView extends StatefulWidget {
  final VoidCallback? onBack;

  const ChangePasswordView({
    super.key,
    this.onBack,
  });

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          ChangePasswordRequested(
            currentPassword: _currentPasswordController.text.trim(),
            newPassword: _newPasswordController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          _formKey.currentState?.reset();
        }

        if (state is AuthFailure) {
          AppSnackBar.showError(
            context,
            message: state.message,
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button + Title row
            Row(
              children: [
                if (widget.onBack != null) ...[
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _currentPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                      _formKey.currentState?.reset();
                      widget.onBack!();
                    },
                    child: Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: isDark
                            ? tokens.border.withValues(alpha: 0.5)
                            : tokens.background,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: tokens.text,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(
                    'Change Password',
                    style: AppUrbanist.sectionTitle(color: tokens.text),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.only(left: widget.onBack != null ? 48.w : 0),
              child: Text(
                'Update your password to keep your account secure',
                style: AppUrbanist.body(
                  color: tokens.mutedText,
                  fontSize: 13.sp,
                ),
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Info Banner
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? tokens.tileLavender.withValues(alpha: 0.35)
                    : tokens.tileLavender,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border(
                  left: BorderSide(color: tokens.accent, width: 3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: tokens.accent,
                    size: 20.sp,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Enter your current password and choose a new password for your account.',
                      style: AppUrbanist.body(
                        color: tokens.text,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Current Password
            PasswordField(
              controller: _currentPasswordController,
              label: 'Current password',
              hint: 'Enter your current password',
              obscureText: _obscureCurrentPassword,
              tokens: tokens,
              isDark: isDark,
              accentColor: tokens.accent,
              onToggleVisibility: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your current password';
                }
                return null;
              },
            ),

            SizedBox(height: AppSpacing.md),

            // New Password
            PasswordField(
              controller: _newPasswordController,
              label: 'New password',
              hint: 'Enter your new password',
              obscureText: _obscureNewPassword,
              tokens: tokens,
              isDark: isDark,
              accentColor: tokens.accent,
              onToggleVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            SizedBox(height: AppSpacing.md),

            // Confirm Password
            PasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm new password',
              hint: 'Re-enter your new password',
              obscureText: _obscureConfirmPassword,
              tokens: tokens,
              isDark: isDark,
              accentColor: tokens.accent,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            SizedBox(height: AppSpacing.xl),

            // Update Password Button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: FilledButton(
                    onPressed: isLoading ? null : _changePassword,
                    style: FilledButton.styleFrom(
                      backgroundColor: tokens.accent,
                      disabledBackgroundColor:
                          tokens.accent.withValues(alpha: 0.4),
                      foregroundColor: tokens.onAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: tokens.onAccent,
                            ),
                          )
                        : Text(
                            'Update Password',
                            style: AppUrbanist.saveButton(
                              color: tokens.onAccent,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Password Field — reusable labelled input matching app field style
// =============================================================================

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?) validator;
  final HabitFlowTokens tokens;
  final bool isDark;
  final Color? accentColor;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.validator,
    required this.tokens,
    required this.isDark,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccent = accentColor ?? tokens.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(
          label,
          style: AppUrbanist.body(
            color: tokens.mutedText,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),

        // Text field
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: AppUrbanist.body(
            color: tokens.text,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppUrbanist.body(
              color: tokens.mutedText.withValues(alpha: 0.60),
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: tokens.field,
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: tokens.mutedText,
              size: 20.sp,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: tokens.mutedText,
                size: 20.sp,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: tokens.hairline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: tokens.hairline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: effectiveAccent, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}