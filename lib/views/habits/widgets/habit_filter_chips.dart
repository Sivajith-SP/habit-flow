import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
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
            padding: EdgeInsets.only(right: AppSpacing.sm),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 9.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.45),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected
                  ? FontWeight.w700
                  : FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}