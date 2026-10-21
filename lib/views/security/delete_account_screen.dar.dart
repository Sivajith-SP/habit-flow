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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: tokens.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: tokens.text,
            ),
          ),
          title: Text(
            'Delete Account',
            style: AppUrbanist.sectionTitle(color: tokens.text),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                20.w,
                12.h,
                20.w,
                100.h,
              ),
              children: [
                // ── Warning Banner ────────────────────────────────────────
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark
                        ? tokens.tilePink.withValues(alpha: 0.45)
                        : AppColors.error.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border(
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

                // ── Confirm Password Section ──────────────────────────────
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

                // ── Password Field ────────────────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: AppUrbanist.body(
                        color: tokens.mutedText,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                      style: AppUrbanist.body(
                        color: tokens.text,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
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
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
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
                          borderSide: const BorderSide(
                            color: AppColors.error,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide:
                              const BorderSide(color: AppColors.error),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: const BorderSide(
                            color: AppColors.error,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xl),

                // ── Delete Account Button ─────────────────────────────────
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
                            borderRadius:
                                BorderRadius.circular(AppRadius.pill),
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
        ),
      ),
    );
  }
}
