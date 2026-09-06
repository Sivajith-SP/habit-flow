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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController =
  TextEditingController();

  final _newPasswordController =
  TextEditingController();

  final _confirmPasswordController =
  TextEditingController();

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
        currentPassword:
        _currentPasswordController.text.trim(),
        newPassword:
        _newPasswordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
              Text('Password changed successfully.'),
            ),
          );

          Navigator.pop(context);
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints:
                      const BoxConstraints(),
                      splashRadius: 22.r,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color:
                        colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(
                      width: AppSpacing.md,
                    ),

                    Text(
                      'Change Password',
                      style:
                      AppTextStyles.heading1.copyWith(
                        fontSize: 26.sp,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        colorScheme.onSurface,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                Padding(
                  padding:
                  EdgeInsets.only(left: 48.w),
                  child: Text(
                    'Update your account password',
                    style:
                    AppTextStyles.body.copyWith(
                      fontSize: 14.sp,
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ),

                SizedBox(
                  height: AppSpacing.xl,
                ),

                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics:
                      const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: 100.h,
                      ),
                      children: [
                        // Security information
                        Container(
                          padding: EdgeInsets.all(
                            AppSpacing.md,
                          ),
                          decoration:
                          BoxDecoration(
                            color: colorScheme.primary
                                .withValues(
                              alpha: 0.08,
                            ),
                            borderRadius:
                            BorderRadius.circular(
                              AppRadius.md,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Icon(
                                Icons
                                    .info_outline_rounded,
                                color: colorScheme
                                    .primary,
                                size: 21.sp,
                              ),

                              SizedBox(
                                width:
                                AppSpacing.sm,
                              ),

                              Expanded(
                                child: Text(
                                  'Enter your current password and choose a new password for your account.',
                                  style: AppTextStyles
                                      .caption
                                      .copyWith(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: AppSpacing.xl,
                        ),

                        // Current password
                        _PasswordField(
                          controller:
                          _currentPasswordController,
                          label:
                          'Current Password',
                          hint:
                          'Enter your current password',
                          obscureText:
                          _obscureCurrentPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscureCurrentPassword =
                              !_obscureCurrentPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Enter your current password';
                            }

                            return null;
                          },
                        ),

                        SizedBox(
                          height: AppSpacing.md,
                        ),

                        // New password
                        _PasswordField(
                          controller:
                          _newPasswordController,
                          label: 'New Password',
                          hint:
                          'Enter your new password',
                          obscureText:
                          _obscureNewPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscureNewPassword =
                              !_obscureNewPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Enter a new password';
                            }

                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }

                            return null;
                          },
                        ),

                        SizedBox(
                          height: AppSpacing.md,
                        ),

                        // Confirm password
                        _PasswordField(
                          controller:
                          _confirmPasswordController,
                          label:
                          'Confirm New Password',
                          hint:
                          'Re-enter your new password',
                          obscureText:
                          _obscureConfirmPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Confirm your new password';
                            }

                            if (value !=
                                _newPasswordController
                                    .text) {
                              return 'Passwords do not match';
                            }

                            return null;
                          },
                        ),

                        SizedBox(
                          height: AppSpacing.xl,
                        ),

                        // Save button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder:
                              (context, state) {
                            final isLoading =
                            state is AuthLoading;

                            return SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: FilledButton(
                                onPressed: isLoading
                                    ? null
                                    : _changePassword,
                                style:
                                FilledButton
                                    .styleFrom(
                                  backgroundColor:
                                  colorScheme
                                      .primary,
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      AppRadius.md,
                                    ),
                                  ),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth:
                                    2.5,
                                    color:
                                    colorScheme
                                        .onPrimary,
                                  ),
                                )
                                    : Text(
                                  'Update Password',
                                  style: AppTextStyles
                                      .button
                                      .copyWith(
                                    color:
                                    colorScheme
                                        .onPrimary,
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

// -----------------------------------------------------------------------------
// Password Field
// -----------------------------------------------------------------------------

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: AppTextStyles.body.copyWith(
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color:
            colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}