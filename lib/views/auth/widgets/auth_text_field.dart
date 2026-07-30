import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_durations.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final bool enabled;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.autofillHints,
    this.enabled = true,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  bool _hasFocus = false;

  late final FocusNode _focusNode;
  late final AnimationController _focusAnim;
  late final Animation<double> _focusFade;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _hasFocus = _focusNode.hasFocus);
        if (_focusNode.hasFocus) {
          _focusAnim.forward();
        } else {
          _focusAnim.reverse();
        }
      });

    _focusAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _focusFade = CurvedAnimation(parent: _focusAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _focusFade,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              // Focus glow
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: 0.18 * _focusFade.value,
                ),
                blurRadius: 16,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        );
      },
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        onFieldSubmitted: widget.onFieldSubmitted,
        obscureText: widget.isPassword ? _obscureText : false,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.spaceGrotesk(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary.withValues(alpha: .65),
          ),

          filled: true,
          // Slightly off-white for a soft, high-quality feel
          fillColor: _hasFocus
              ? Colors.white.withValues(alpha: .95)
              : Colors.white.withValues(alpha: .80),

          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 18.h,
          ),

          prefixIcon: AnimatedContainer(
            duration: AppDurations.fast,
            child: Icon(
              widget.prefixIcon,
              color: _hasFocus
                  ? AppColors.primary
                  : AppColors.textSecondary.withValues(alpha: .7),
              size: 21.sp,
            ),
          ),

          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () =>
                      setState(() => _obscureText = !_obscureText),
                  icon: AnimatedSwitcher(
                    duration: AppDurations.fast,
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      key: ValueKey(_obscureText),
                      color: AppColors.textSecondary.withValues(alpha: .65),
                      size: 21.sp,
                    ),
                  ),
                )
              : null,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(
              color: AppColors.border.withValues(alpha: .70),
              width: 1.2,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.6,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.2,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.6,
            ),
          ),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(
              color: AppColors.disabled,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}