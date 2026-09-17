import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_event.dart';
import '../../controllers/auth/auth_state.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
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
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: Text(
            'Delete Account?',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'This action cannot be undone. Your HabitFlow account will be permanently deleted.',
            style: AppTextStyles.body.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.body.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
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
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pop();
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Text(
                      'Delete Account',
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                Padding(
                  padding: EdgeInsets.only(left: 48.w),
                  child: Text(
                    'Permanently remove your account',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 100.h),
                      children: [
                        // Warning
                        Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.error,
                                size: 22.sp,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  'Deleting your account is permanent. Your account cannot be recovered after deletion.',
                                  style: AppTextStyles.caption.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSpacing.xl),

                        Text(
                          'Confirm your password',
                          style: AppTextStyles.title.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: AppSpacing.sm),

                        Text(
                          'Enter your current password to confirm that you want to delete your account.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),

                        SizedBox(height: AppSpacing.lg),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your password';
                            }

                            return null;
                          },
                          style: AppTextStyles.body.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: AppSpacing.xl),

                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;

                            return SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: FilledButton(
                                onPressed: isLoading ? null : _deleteAccount,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  disabledBackgroundColor: AppColors.error
                                      .withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                  ),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Delete Account',
                                        style: AppTextStyles.button.copyWith(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
