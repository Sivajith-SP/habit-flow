import 'package:flutter/material.dart';

import '../../../../app/theme/app_flow_tokens.dart';
import '../../../../models/habit/habit_frequency.dart';
import 'bento_cell.dart';

class DayInfo {
  final int day;
  final String label;
  final String fullName;

  const DayInfo(this.day, this.label, this.fullName);
}

/// DaysCell manages weekday selection for weekly and custom habits.
///
/// Features:
/// - Background: `tilePink`
/// - Label: "Days"
/// - 7 day circles (M, T, W, T, F, S, S) in a 4-column wrap (4 on row 1, 3 on row 2), 6px gaps
/// - 34px circle diameter, 13 / w700
/// - Selected: `ink` with `onInk` text
/// - Unselected: `chipOverlay` with `text` color
/// - When Daily: disabled, dimmed to 35% via AnimatedOpacity (250ms), caption "Every day"
/// - When Weekly: enabled in single-select mode, caption "Once a week"
/// - When Custom: enabled in multi-select mode, caption "{n} selected" (or "Every day" if 7 selected)
class DaysCell extends StatelessWidget {
  final HabitFrequency frequency;
  final Set<int> selectedDays;
  final ValueChanged<int> onDayToggled;

  bool get isDaily => frequency == HabitFrequency.daily;

  static const List<DayInfo> firstRow = [
    DayInfo(1, 'M', 'Monday'),
    DayInfo(2, 'T', 'Tuesday'),
    DayInfo(3, 'W', 'Wednesday'),
    DayInfo(4, 'T', 'Thursday'),
  ];

  static const List<DayInfo> secondRow = [
    DayInfo(5, 'F', 'Friday'),
    DayInfo(6, 'S', 'Saturday'),
    DayInfo(7, 'S', 'Sunday'),
  ];

  const DaysCell({
    super.key,
    HabitFrequency? frequency,
    bool? isDaily,
    required this.selectedDays,
    required this.onDayToggled,
  }) : frequency = frequency ??
            (isDaily == true
                ? HabitFrequency.daily
                : HabitFrequency.custom);

  Widget _buildDayCircle(BuildContext context, DayInfo info, HabitFlowTokens tokens) {
    final isSelected = isDaily || selectedDays.contains(info.day);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label: info.fullName,
      selected: isSelected,
      button: !isDaily,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isDaily ? null : () => onDayToggled(info.day),
        child: AnimatedContainer(
          duration: disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? tokens.ink : tokens.chipOverlay,
          ),
          alignment: Alignment.center,
          child: Text(
            info.label,
            style: AppUrbanist.dayCircle(
              color: isSelected ? tokens.onInk : tokens.text,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final String captionText;
    switch (frequency) {
      case HabitFrequency.daily:
        captionText = 'Every day';
        break;
      case HabitFrequency.weekly:
        captionText = 'Once a week';
        break;
      case HabitFrequency.custom:
        captionText = selectedDays.length == 7
            ? 'Every day'
            : '${selectedDays.length} selected';
        break;
    }

    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return BentoCell(
      label: 'Days',
      backgroundColor: tokens.tilePink,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IgnorePointer(
            ignoring: isDaily,
            child: AnimatedOpacity(
              duration: disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 250),
              opacity: isDaily ? 0.35 : 1.0,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row 1 (M T W T)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: firstRow.map((info) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.5),
                          child: _buildDayCircle(context, info, tokens),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 6),
                    // Row 2 (F S S)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: secondRow.map((info) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.5),
                          child: _buildDayCircle(context, info, tokens),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Caption
          Center(
            child: Text(
              captionText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppUrbanist.daysCaption(
                color: tokens.text.withValues(alpha: 0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
