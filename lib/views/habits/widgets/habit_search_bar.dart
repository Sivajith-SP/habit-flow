import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class HabitSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const HabitSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.35),
            ),
            boxShadow: isDark ? null : AppShadows.soft,
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: AppTextStyles.body.copyWith(
              fontSize: 15.sp,
              color: colorScheme.onSurface,
            ),
            cursorColor: colorScheme.primary,
            decoration: InputDecoration(
              hintText: 'Search habits...',
              hintStyle: AppTextStyles.body.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 15.sp,
              ),

              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 10.w,
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 22.sp,
                ),
              ),

              prefixIconConstraints: const BoxConstraints(),

              suffixIcon: hasText
                  ? GestureDetector(
                onTap: () {
                  controller.clear();
                  onChanged?.call('');
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Container(
                    width: 22.r,
                    height: 22.r,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: colorScheme.primary,
                      size: 14.sp,
                    ),
                  ),
                ),
              )
                  : null,

              suffixIconConstraints: const BoxConstraints(),

              filled: false,

              contentPadding: EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.md,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                borderSide: BorderSide.none,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                borderSide: BorderSide.none,
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }
}