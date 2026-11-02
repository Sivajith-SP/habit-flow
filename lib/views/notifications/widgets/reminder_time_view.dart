import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../controllers/notifications/notifications_bloc.dart';
import '../../../controllers/notifications/notifications_event.dart';

// =============================================================================
// ReminderTimeView – In-sheet subview with drum-roll time picker
// =============================================================================

class ReminderTimeView extends StatefulWidget {
  final int initialHour;   // 0-23
  final int initialMinute; // 0-59
  final VoidCallback onBack;
  final VoidCallback onSaved;

  const ReminderTimeView({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.onBack,
    required this.onSaved,
  });

  @override
  State<ReminderTimeView> createState() => _ReminderTimeViewState();
}

class _ReminderTimeViewState extends State<ReminderTimeView> {
  late int _selectedHour12; // 1-12
  late int _selectedMinute; // 0-59
  late bool _isAm;

  late final FixedExtentScrollController _hourCtrl;
  late final FixedExtentScrollController _minuteCtrl;

  @override
  void initState() {
    super.initState();

    final tod = TimeOfDay(
      hour: widget.initialHour,
      minute: widget.initialMinute,
    );
    _isAm = tod.period == DayPeriod.am;
    _selectedHour12 = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    _selectedMinute = tod.minute;

    // Zero-bias initialItem directly maps index to the exact item
    _hourCtrl = FixedExtentScrollController(
      initialItem: _selectedHour12 - 1,
    );
    _minuteCtrl = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  int get _hour24 {
    if (_isAm) {
      return _selectedHour12 == 12 ? 0 : _selectedHour12;
    } else {
      return _selectedHour12 == 12 ? 12 : _selectedHour12 + 12;
    }
  }

  void _saveTime() {
    context.read<NotificationsBloc>().add(
          ReminderTimeChanged(
            hour: _hour24,
            minute: _selectedMinute,
          ),
        );
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8.h,
        AppSpacing.screenPadding,
        28.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header with circular back button ───────────────────────────────
          Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: isDark
                        ? tokens.border.withValues(alpha: 0.5)
                        : tokens.background,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: tokens.text,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Reminder Time',
                  style: AppUrbanist.sectionTitle(color: tokens.text),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 48.w),
            child: Text(
              'When should HabitFlow remind you?',
              style: AppUrbanist.body(
                color: tokens.mutedText,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 28.h),

          // ── Accurate Drum-roll Time Picker Row ────────────────────────────
          _DrumRollPicker(
            hourCtrl: _hourCtrl,
            minuteCtrl: _minuteCtrl,
            selectedHour12: _selectedHour12,
            selectedMinute: _selectedMinute,
            isAm: _isAm,
            tokens: tokens,
            isDark: isDark,
            onHourChanged: (h) => setState(() => _selectedHour12 = h),
            onMinuteChanged: (m) => setState(() => _selectedMinute = m),
            onAmPmChanged: (isAm) => setState(() => _isAm = isAm),
          ),

          SizedBox(height: 32.h),

          // ── Save Time Button ───────────────────────────────────────────────
          FilledButton(
            onPressed: _saveTime,
            style: FilledButton.styleFrom(
              backgroundColor: tokens.accent,
              foregroundColor: tokens.onAccent,
              minimumSize: Size(double.infinity, 52.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
            child: Text(
              'Save Time',
              style: AppUrbanist.body(
                color: tokens.onAccent,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _DrumRollPicker – Hours, colon, Minutes, and AM/PM capsule
// =============================================================================

class _DrumRollPicker extends StatelessWidget {
  final FixedExtentScrollController hourCtrl;
  final FixedExtentScrollController minuteCtrl;
  final int selectedHour12;
  final int selectedMinute;
  final bool isAm;
  final HabitFlowTokens tokens;
  final bool isDark;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<bool> onAmPmChanged;

  const _DrumRollPicker({
    required this.hourCtrl,
    required this.minuteCtrl,
    required this.selectedHour12,
    required this.selectedMinute,
    required this.isAm,
    required this.tokens,
    required this.isDark,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onAmPmChanged,
  });

  @override
  Widget build(BuildContext context) {
    const itemExtent = 46.0;

    return SizedBox(
      height: itemExtent * 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Hours column (01-12) ─────────────────────────────────────────
          _WheelColumn(
            controller: hourCtrl,
            itemExtent: itemExtent,
            onSelectedItemChanged: (index) {
              final h = ((index % 12 + 12) % 12) + 1;
              if (h != selectedHour12) {
                onHourChanged(h);
              }
            },
            builder: (index) {
              final h = ((index % 12 + 12) % 12) + 1;
              final isSelected = h == selectedHour12;
              return Center(
                child: Text(
                  h.toString().padLeft(2, '0'),
                  style: AppUrbanist.body(
                    color: isSelected ? tokens.text : tokens.mutedText,
                    fontSize: isSelected ? 26.sp : 17.sp,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              );
            },
          ),

          // ── Colon separator ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              ':',
              style: AppUrbanist.body(
                color: tokens.text,
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // ── Minutes column (00-59) ───────────────────────────────────────
          _WheelColumn(
            controller: minuteCtrl,
            itemExtent: itemExtent,
            onSelectedItemChanged: (index) {
              final m = (index % 60 + 60) % 60;
              if (m != selectedMinute) {
                onMinuteChanged(m);
              }
            },
            builder: (index) {
              final m = (index % 60 + 60) % 60;
              final isSelected = m == selectedMinute;
              return Center(
                child: Text(
                  m.toString().padLeft(2, '0'),
                  style: AppUrbanist.body(
                    color: isSelected ? tokens.text : tokens.mutedText,
                    fontSize: isSelected ? 26.sp : 17.sp,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              );
            },
          ),

          SizedBox(width: 20.w),

          // ── Horizontal AM / PM Capsule Toggle ────────────────────────────
          _AmPmCapsule(
            isAm: isAm,
            tokens: tokens,
            isDark: isDark,
            onChanged: onAmPmChanged,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _WheelColumn – ListWheelScrollView with zero-bias wrap-around
// =============================================================================

class _WheelColumn extends StatelessWidget {
  final FixedExtentScrollController controller;
  final double itemExtent;
  final ValueChanged<int> onSelectedItemChanged;
  final Widget Function(int index) builder;

  const _WheelColumn({
    required this.controller,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58.w,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: itemExtent,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.003,
        diameterRatio: 1.6,
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) => builder(index),
        ),
      ),
    );
  }
}

// =============================================================================
// _AmPmCapsule – Horizontal [ AM | PM ] toggle
// =============================================================================

class _AmPmCapsule extends StatelessWidget {
  final bool isAm;
  final HabitFlowTokens tokens;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _AmPmCapsule({
    required this.isAm,
    required this.tokens,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: isDark ? tokens.surface : const Color(0xFFF1EEF8),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CapsuleItem(
            label: 'AM',
            selected: isAm,
            tokens: tokens,
            onTap: () => onChanged(true),
          ),
          _CapsuleItem(
            label: 'PM',
            selected: !isAm,
            tokens: tokens,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _CapsuleItem extends StatelessWidget {
  final String label;
  final bool selected;
  final HabitFlowTokens tokens;
  final VoidCallback onTap;

  const _CapsuleItem({
    required this.label,
    required this.selected,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 9.h,
        ),
        decoration: BoxDecoration(
          color: selected ? tokens.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppUrbanist.body(
            color: selected ? tokens.onAccent : tokens.mutedText,
            fontSize: 13.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
