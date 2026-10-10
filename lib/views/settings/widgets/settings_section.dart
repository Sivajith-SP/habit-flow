import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final Widget? child;
  final List<Widget>? children;

  const SettingsSection({
    super.key,
    required this.title,
    this.child,
    this.children,
  }) : assert(child != null || children != null, 'Either child or children must be provided');

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label (uppercase, letter-spaced)
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
          child: Text(
            title.toUpperCase(),
            style: AppUrbanist.body(
              color: tokens.mutedText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ).copyWith(letterSpacing: 1.2),
          ),
        ),

        if (child != null)
          child!
        else if (children != null)
          // Rounded card container matching dashboard / statistics style
          Container(
            decoration: BoxDecoration(
              color: isDark ? tokens.raised : tokens.surface,
              borderRadius: BorderRadius.circular(22.r),
              border: isDark ? Border.all(color: tokens.border, width: 1) : null,
              boxShadow: isDark ? null : tokens.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Column(
                children: [
                  for (int i = 0; i < children!.length; i++) ...[
                    children![i],
                    if (i < children!.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 72.w,
                        endIndent: 16.w,
                        color: isDark
                            ? tokens.border.withValues(alpha: 0.5)
                            : const Color(0xFFF0EDF6),
                      ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
