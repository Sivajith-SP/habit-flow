import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final double pageValue;
  final int itemCount;

  const PageIndicator({
    super.key,
    required this.pageValue,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = AppColors.border;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        itemCount,
        (index) {
          // Distance between this dot's index and current continuous scroll position
          final distance = (index - pageValue).abs();

          // Smooth width interpolation: active is 22.w, inactive is 6.w
          final double width = (22 - (distance.clamp(0.0, 1.0) * 16)).w;

          // Smooth color interpolation between active and inactive color
          final color = Color.lerp(
            activeColor,
            inactiveColor,
            distance.clamp(0.0, 1.0),
          ) ?? activeColor;

          return Container(
            margin: EdgeInsets.only(right: 6.w),
            width: width,
            height: 6.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3.r),
            ),
          );
        },
      ),
    );
  }
}