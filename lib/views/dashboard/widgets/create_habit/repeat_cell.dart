import 'package:flutter/material.dart';

import '../../../../app/theme/app_flow_tokens.dart';
import '../../../../models/habit/habit_frequency.dart';
import 'bento_cell.dart';

/// RepeatCell contains pill options for Daily, Weekly, and Custom frequency.
///
/// Features:
/// - Background: `tileButter`
/// - Label: "Repeat"
/// - 3 stacked pill buttons (38px tall, StadiumBorder, 14 / w700)
/// - Selected: `ink` background with `onInk` text
/// - Unselected: `chipOverlay` background with `text` color
/// - AnimatedContainer transitions over 200ms (respects reduced motion)
class RepeatCell extends StatelessWidget {
  final HabitFrequency frequency;
  final ValueChanged<HabitFrequency> onFrequencyChanged;

  const RepeatCell({
    super.key,
    required this.frequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    final options = [
      (HabitFrequency.daily, 'Daily'),
      (HabitFrequency.weekly, 'Weekly'),
      (HabitFrequency.custom, 'Custom'),
    ];

    return BentoCell(
      label: 'Repeat',
      backgroundColor: tokens.tileButter,
      child: Column(
        children: options.map((option) {
          final isSelected = frequency == option.$1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Semantics(
              label: '${option.$2} frequency',
              selected: isSelected,
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onFrequencyChanged(option.$1),
                child: AnimatedContainer(
                  duration: disableAnimations
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  height: 38,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: isSelected ? tokens.ink : tokens.chipOverlay,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    option.$2,
                    style: AppUrbanist.pillButton(
                      color: isSelected ? tokens.onInk : tokens.text,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
