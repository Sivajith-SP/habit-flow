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

    final effectiveIconBg =
        iconBg ?? tokens.tileLavender;
    final effectiveIconColor =
        iconColor ?? tokens.tileLavenderIcon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 13.h,
          ),
          child: Row(
            children: [
              // Squircle icon badge
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: effectiveIconBg,
                  borderRadius: BorderRadius.circular(13.r),
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
                        fontSize: 15,
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
                          fontSize: 12,
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