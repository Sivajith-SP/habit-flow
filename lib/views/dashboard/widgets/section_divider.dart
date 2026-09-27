import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_flow_tokens.dart';

class SectionDivider extends StatelessWidget {
  final String label;
  final IconData? icon;

  const SectionDivider({
    super.key,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return Row(
      children: [
        // Left hairline line
        Expanded(
          child: Container(
            height: 1,
            color: tokens.mutedText.withValues(alpha: 0.25),
          ),
        ),

        // Center content: icon (optional) + label
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16.sp,
                  color: tokens.mutedText,
                ),
                SizedBox(width: 6.w),
              ],
              Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: tokens.mutedText,
                ),
              ),
            ],
          ),
        ),

        // Right hairline line
        Expanded(
          child: Container(
            height: 1,
            color: tokens.mutedText.withValues(alpha: 0.25),
          ),
        ),
      ],
    );
  }
}
