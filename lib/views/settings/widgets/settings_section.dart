import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: AppSpacing.sm),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
              letterSpacing: 1.1,
            ),
          ),
        ),

        // Card container for tiles
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 44.w + AppSpacing.md * 2, // align with text start
                    endIndent: AppSpacing.md,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
