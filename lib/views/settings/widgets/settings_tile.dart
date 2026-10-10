import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveIconBg = iconBg ?? tokens.tileLavenderIcon;
    final effectiveIconColor =
        iconColor ?? (isDark ? tokens.background : Colors.white);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
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
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: effectiveIconColor,
                  size: 20.sp,
                ),
              ),

              SizedBox(width: 14.w),

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
                      SizedBox(height: 2.h),
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

              SizedBox(width: 8.w),

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