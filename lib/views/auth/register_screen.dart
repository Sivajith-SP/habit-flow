import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:habitflow/app/router/app_routes.dart';
import 'package:habitflow/controllers/auth/auth_bloc.dart';
import 'package:habitflow/controllers/auth/auth_event.dart';
import 'package:habitflow/controllers/auth/auth_state.dart';
import 'package:habitflow/core/utils/validators.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    context.read<AuthBloc>().add(
      RegisterRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(AppRoutes.dashboard);
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80.h),

                    Text("Create Account", style: AppTextStyles.heading1),

                    SizedBox(height: AppSpacing.sm),

                    Text(
                      "Create your HabitFlow account",
                      style: AppTextStyles.bodySmall,
                    ),

                    SizedBox(height: 48.h),

                    AuthTextField(
                      controller: _nameController,
                      hintText: "Full Name",
                      prefixIcon: Icons.person_outline,
                      validator: Validators.requiredField,
                    ),

                    SizedBox(height: AppSpacing.md),

                    AuthTextField(
                      hintText: "Email",
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),

                    SizedBox(height: AppSpacing.md),

                    AuthTextField(
                      hintText: "Password",
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: Validators.password,
                    ),

                    SizedBox(height: AppSpacing.md),

                    AuthTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppSpacing.lg),

                    AuthButton(
                      text: "Create Account",
                      isLoading: state is AuthLoading,
                      onPressed: _register,
                    ),

                    SizedBox(height: 32.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: AppTextStyles.bodySmall,
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.login);
                          },
                          child: Text("Login", style: AppTextStyles.title),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
