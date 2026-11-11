import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import 'habit_filter.dart';

class HabitFilterChips extends StatelessWidget {
  final HabitFilter selected;
  final ValueChanged<HabitFilter> onSelected;

  const HabitFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: HabitFilter.values.map((filter) {
          final isSelected = filter == selected;

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: _FilterPill(
              label: _label(filter),
              isSelected: isSelected,
              onTap: () => onSelected(filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(HabitFilter filter) {
    switch (filter) {
      case HabitFilter.all:
        return 'All';
      case HabitFilter.daily:
        return 'Daily';
      case HabitFilter.weekly:
        return 'Weekly';
      case HabitFilter.custom:
        return 'Custom';
      case HabitFilter.archived:
        return 'Archived';
    }
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 9.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? tokens.accent
                : (isDark ? tokens.raised : tokens.surface),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? tokens.accent
                  : (isDark ? tokens.border : tokens.hairline),
              width: 1,
            ),
            boxShadow: (!isSelected && !isDark)
                ? [
                    BoxShadow(
                      color: const Color(0xFF5B43B5).withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: AppUrbanist.body(
              color: isSelected ? Colors.white : tokens.text,
              fontSize: 13.5.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
