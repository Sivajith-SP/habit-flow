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
import 'change_password_screen.dart';

// =============================================================================
// Standalone Delete Account Screen
// =============================================================================

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 36.h),
          child: DeleteAccountView(
            onBack: () => Navigator.maybePop(context),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Reusable Delete Account View (Used in bottom sheet & standalone screen)
// =============================================================================

class DeleteAccountView extends StatefulWidget {
  final VoidCallback? onBack;

  const DeleteAccountView({
    super.key,
    this.onBack,
  });

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _deleteAccount() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    final tokens = context.flowTokens;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: tokens.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: Text(
            'Delete Account?',
            style: AppUrbanist.sectionTitle(color: AppColors.error),
          ),
          content: Text(
            'This action cannot be undone. Your HabitFlow account will be permanently deleted.',
            style: AppUrbanist.body(color: tokens.mutedText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: AppUrbanist.body(
                  color: tokens.mutedText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<AuthBloc>().add(
                      DeleteAccountRequested(
                        password: _passwordController.text.trim(),
                      ),
                    );
              },
              child: Text(
                'Delete Account',
                style: AppUrbanist.body(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pop();
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
                      _passwordController.clear();
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
                    'Delete Account',
                    style: AppUrbanist.sectionTitle(color: AppColors.error),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.only(left: widget.onBack != null ? 48.w : 0),
              child: Text(
                'This action is permanent and cannot be undone.',
                style: AppUrbanist.body(
                  color: tokens.mutedText,
                  fontSize: 13.sp,
                ),
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Warning banner
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? tokens.tilePink.withValues(alpha: 0.45)
                    : AppColors.error.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: const Border(
                  left: BorderSide(color: AppColors.error, width: 3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 20.sp,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Deleting your account is permanent. Your account cannot be recovered after deletion.',
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

            // Confirm password heading
            Text(
              'Confirm your password',
              style: AppUrbanist.habitName(color: tokens.text),
            ),
            SizedBox(height: 6.h),
            Text(
              'Enter your current password to confirm that you want to delete your account.',
              style: AppUrbanist.body(
                color: tokens.mutedText,
                fontSize: 13.sp,
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Password field (reusing PasswordField)
            PasswordField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              obscureText: _obscurePassword,
              tokens: tokens,
              isDark: isDark,
              accentColor: AppColors.error,
              onToggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your password';
                }
                return null;
              },
            ),

            SizedBox(height: AppSpacing.xl),

            // Delete Account button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: FilledButton(
                    onPressed: isLoading ? null : _deleteAccount,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      disabledBackgroundColor:
                          AppColors.error.withValues(alpha: 0.4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Delete Account',
                            style: AppUrbanist.saveButton(
                              color: Colors.white,
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
