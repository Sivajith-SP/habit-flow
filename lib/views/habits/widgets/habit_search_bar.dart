import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

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
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? tokens.raised : tokens.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark ? tokens.border : tokens.hairline,
              width: 1,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF5B43B5).withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: AppUrbanist.body(
              color: tokens.text,
              fontSize: 15.sp,
            ),
            cursorColor: tokens.accent,
            decoration: InputDecoration(
              hintText: 'Search habits...',
              hintStyle: AppUrbanist.body(
                color: tokens.mutedText,
                fontSize: 15.sp,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 10.w,
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: tokens.mutedText,
                  size: 20.sp,
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
                            color: tokens.accent.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: tokens.accent,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(),
              filled: false,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 14.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }
}
