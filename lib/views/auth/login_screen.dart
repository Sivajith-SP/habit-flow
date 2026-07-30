import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_durations.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_event.dart';
import '../../controllers/auth/auth_state.dart';
import '../../core/utils/validators.dart';
import 'widgets/auth_background.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_card.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(AppRoutes.dashboard);
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return AuthBackground(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: TweenAnimationBuilder<double>(
                  duration: AppDurations.slow,
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: .92, end: 1),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - value) * 36),
                      child: Transform.scale(
                        scale: value,
                        child: Opacity(opacity: value, child: child),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Header ───────────────────────────────────────────
                      const AuthHeader(
                        tagline: 'Welcome back',
                        title: 'Good to see you',
                        subtitle: 'Continue building better habits one day at\n a time.',
                      ),

                      SizedBox(height: AppSpacing.xl),

                      // ── Form card ────────────────────────────────────────
                      AuthCard(
                        child: AutofillGroup(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Email field
                                AuthTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.email,
                                ),

                                SizedBox(height: AppSpacing.md),

                                // Password field
                                AuthTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock_outline,
                                  isPassword: true,
                                  validator: Validators.password,
                                ),

                                SizedBox(height: AppSpacing.xs),

                                // Forgot password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // TODO: Forgot password
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.sm,
                                        vertical: AppSpacing.xs,
                                      ),
                                    ),
                                    child: Text(
                                      'Forgot Password?',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: AppSpacing.sm),

                                // Continue / Login button
                                AuthButton(
                                  text: 'Continue',
                                  isLoading: state is AuthLoading,
                                  onPressed: _login,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.xl),

                      // ── Create Account link ──────────────────────────────
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: AppTextStyles.bodySmall,
                            ),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.register),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                              ),
                              child: Text(
                                'Create Account',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
