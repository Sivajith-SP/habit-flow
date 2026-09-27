import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_flow_tokens.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final systemBottom = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 24.h + (systemBottom > 0 ? systemBottom : 0),
      ),
      child: Container(
        height: 74.h,
        decoration: BoxDecoration(
          color: tokens.raised,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isDark ? null : tokens.cardShadow,
          border: isDark ? Border.all(color: tokens.border, width: 1) : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 0: Home
            _buildNavItem(
              context: context,
              index: 0,
              icon: Icons.home_rounded,
              label: 'Home',
              tokens: tokens,
            ),

            // 1: Habits
            _buildNavItem(
              context: context,
              index: 1,
              icon: Icons.check_circle_outline_rounded,
              label: 'Habits',
              tokens: tokens,
            ),

            // Center: Add Button (58px circle)
            Semantics(
              button: true,
              label: 'Add habit',
              child: InkWell(
                onTap: onAddTap,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 58.r,
                  height: 58.r,
                  decoration: BoxDecoration(
                    color: tokens.centerPlusBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_rounded,
                      color: tokens.centerPlusIcon,
                      size: 28.sp,
                    ),
                  ),
                ),
              ),
            ),

            // 2: Stats
            _buildNavItem(
              context: context,
              index: 2,
              icon: Icons.show_chart_rounded,
              label: 'Statistics',
              tokens: tokens,
            ),

            // 3: Settings
            _buildNavItem(
              context: context,
              index: 3,
              icon: Icons.tune_rounded,
              label: 'Settings',
              tokens: tokens,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required HabitFlowTokens tokens,
  }) {
    final isSelected = currentIndex == index;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkResponse(
        onTap: () => onTap(index),
        radius: 28.r,
        splashColor: tokens.accent.withValues(alpha: 0.15),
        highlightShape: BoxShape.circle,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 44.r, minHeight: 44.r),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isSelected ? 48.r : 44.r,
              height: isSelected ? 48.r : 44.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? tokens.accent : Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 24.sp,
                  color: isSelected ? tokens.onAccent : tokens.mutedText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
