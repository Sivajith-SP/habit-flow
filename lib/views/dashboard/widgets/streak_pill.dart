import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_flow_tokens.dart';

class StreakPill extends StatelessWidget {
  final int streak;

  const StreakPill({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String label = streak > 0 ? '$streak day streak' : 'Start a streak';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: ShapeDecoration(
        color: tokens.tileButter,
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20.r,
            height: 20.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tokens.raised.withValues(alpha: isDark ? 0.25 : 0.50),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.local_fire_department_rounded,
              color: tokens.tileButterIcon,
              size: 13.sp,
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: tokens.text,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
