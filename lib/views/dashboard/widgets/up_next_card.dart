import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_radius.dart';
import '../../../models/habit/habit_frequency.dart';
import '../../../models/habit/habit_with_completion.dart';
import 'create_habit/icon_cell.dart';

class UpNextCard extends StatelessWidget {
  final HabitWithCompletion habit;
  final int colorIndex;
  final VoidCallback onDone;

  const UpNextCard({
    super.key,
    required this.habit,
    required this.colorIndex,
    required this.onDone,
  });

  (Color bg, Color iconTint) _getPastelPair(HabitFlowTokens tokens) {
    final cycle = (habit.habit.colorValue >= 0 && habit.habit.colorValue <= 3)
        ? habit.habit.colorValue
        : colorIndex % 4;
    switch (cycle) {
      case 0:
        return (tokens.tileMint, tokens.tileMintIcon);
      case 1:
        return (tokens.tilePink, tokens.tilePinkIcon);
      case 2:
        return (tokens.tileButter, tokens.tileButterIcon);
      default:
        return (tokens.tileLavender, tokens.tileLavenderIcon);
    }
  }

  String _subtitleText() {
    String base = habit.habit.description.trim();
    if (base.isEmpty) {
      switch (habit.habit.frequency) {
        case HabitFrequency.daily:
          base = 'Daily';
          break;
        case HabitFrequency.weekly:
          base = 'Weekly';
          break;
        case HabitFrequency.custom:
          base = 'Custom';
          break;
      }
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (pastelBg, pastelIconTint) = _getPastelPair(tokens);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: pastelBg,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: isDark ? null : tokens.cardShadow,
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: "Up next" label
          Text(
            'Up next',
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: tokens.text.withValues(alpha: 0.70),
            ),
          ),

          SizedBox(height: 12.h),

          // Row: 64px icon tile + Habit Name & Goal
          Row(
            children: [
              // 64px Icon Tile with 24px radius and chip overlay background
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: tokens.raised.withValues(alpha: isDark ? 0.35 : 0.65),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Center(
                  child: habit.habit.iconCodePoint != 0
                      ? (isEmojiCodePoint(habit.habit.iconCodePoint)
                          ? Text(
                              String.fromCharCode(habit.habit.iconCodePoint),
                              style: TextStyle(fontSize: 28.sp, height: 1),
                            )
                          : Icon(
                              IconData(
                                habit.habit.iconCodePoint,
                                fontFamily: 'MaterialIcons',
                              ),
                              color: pastelIconTint,
                              size: 30.sp,
                            ))
                      : Icon(
                          Icons.check_circle_outline_rounded,
                          color: pastelIconTint,
                          size: 30.sp,
                        ),
                ),
              ),

              SizedBox(width: 16.w),

              // Habit Name & Goal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.habit.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.15,
                        color: tokens.text,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _subtitleText(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: tokens.text.withValues(alpha: 0.70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          // Primary Full-Width Action Button: "Mark as done"
          _MarkAsDoneButton(
            habitName: habit.habit.title,
            tokens: tokens,
            onTap: onDone,
          ),
        ],
      ),
    );
  }
}

class _MarkAsDoneButton extends StatefulWidget {
  final String habitName;
  final HabitFlowTokens tokens;
  final VoidCallback onTap;

  const _MarkAsDoneButton({
    required this.habitName,
    required this.tokens,
    required this.onTap,
  });

  @override
  State<_MarkAsDoneButton> createState() => _MarkAsDoneButtonState();
}

class _MarkAsDoneButtonState extends State<_MarkAsDoneButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Mark ${widget.habitName} as done',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: Container(
            height: 54.h,
            width: double.infinity,
            decoration: ShapeDecoration(
              color: widget.tokens.centerPlusBg,
              shape: const StadiumBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_rounded,
                  color: widget.tokens.centerPlusIcon,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Mark as done',
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: widget.tokens.centerPlusIcon,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
