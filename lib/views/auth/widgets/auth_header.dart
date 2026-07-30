import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

/// Header matching design: small uppercase tagline → large serif title → subtitle.
class AuthHeader extends StatelessWidget {
  final String tagline;
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.tagline = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tagline (e.g. "WELCOME BACK") ───────────────────────────────
        if (tagline.isNotEmpty) ...[
          Text(
            tagline.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: AppSpacing.md),
        ],

        // ── Large Serif Bold Title ───────────────────────────────────────
        Text(
          title,
          style: AppTextStyles.heading1.copyWith(
            fontSize: AppTextStyles.heading1.fontSize,
            fontWeight: FontWeight.w700,
            fontFamily: 'Serif',
            height: 1.15,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppSpacing.gap10),

        // ── Subtitle ────────────────────────────────────────────────────
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
