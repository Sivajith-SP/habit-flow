import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_spacing.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconBg;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconBg,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    final effectiveIconBg = iconBg ?? tokens.tileLavender;
    final effectiveIconColor = iconColor ?? tokens.tileLavenderIcon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.gap14,
          ),
          child: Row(
            children: [
              // Circular accent icon badge
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: effectiveIconBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: effectiveIconColor,
                  size: 20.sp,
                ),
              ),

              SizedBox(width: AppSpacing.gap14),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppUrbanist.body(
                        color: tokens.text,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppUrbanist.body(
                          color: tokens.mutedText,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(width: AppSpacing.sm),

              // Trailing widget or subtle chevron
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: tokens.mutedText.withValues(alpha: 0.60),
                    size: 20.sp,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}