import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_durations.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

class BottomNavBar extends StatefulWidget {
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
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool _isFabPressed = false;

  void _handleFabTap() async {
    setState(() {
      _isFabPressed = true;
    });

    await Future.delayed(const Duration(milliseconds: 120));

    if (mounted) {
      setState(() {
        _isFabPressed = false;
      });
      widget.onAddTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.grid_view_outlined, Icons.grid_view_rounded),
      (Icons.task_alt_outlined, Icons.task_alt_rounded),
      (Icons.insights_outlined, Icons.insights_rounded),
      (Icons.settings_outlined, Icons.settings_rounded),
    ];

    final bool showAddButton = widget.currentIndex == 0;
    final double systemBottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: systemBottomInset > 0 ? systemBottomInset + 8.h : 20.h,
      ),
      child: Row(
        children: [
          // Nav bar pill container
          Expanded(
            child: Container(
              height: 64.h,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final isSelected = widget.currentIndex == index;
                  final item = items[index];

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedScale(
                          duration: AppDurations.fast,
                          scale: isSelected ? 1.15 : 1.0,
                          child: Icon(
                            isSelected ? item.$2 : item.$1,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.35),
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Animated Smooth FAB Transition with Tap Micro-Bounce
          AnimatedContainer(
            duration: AppDurations.normal,
            curve: Curves.easeInOutCubic,
            margin: EdgeInsets.only(left: showAddButton ? AppSpacing.sm : 0),
            width: showAddButton ? 64.h : 0,
            height: 64.h,
            child: AnimatedOpacity(
              duration: AppDurations.fast,
              curve: Curves.easeInOut,
              opacity: showAddButton ? 1.0 : 0.0,
              child: AnimatedScale(
                duration: AppDurations.xFast,
                curve: Curves.easeOutBack,
                scale: showAddButton
                    ? (_isFabPressed ? 0.88 : 1.0)
                    : 0.0,
                child: GestureDetector(
                  onTap: showAddButton ? _handleFabTap : null,
                  child: Container(
                    width: 64.h,
                    height: 64.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryDark,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 250),
                        turns: _isFabPressed ? 0.125 : 0.0,
                        child: Icon(
                          Icons.add_rounded,
                          color: AppColors.white,
                          size: 26.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
