import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../models/habit/habit_frequency.dart';
import '../../../models/habit/habit_with_completion.dart';
import 'create_habit/icon_cell.dart';

class CompactHabitRow extends StatefulWidget {
  final HabitWithCompletion habit;
  final int colorIndex;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  const CompactHabitRow({
    super.key,
    required this.habit,
    required this.colorIndex,
    required this.onToggle,
    this.onTap,
  });

  @override
  State<CompactHabitRow> createState() => _CompactHabitRowState();
}

class _CompactHabitRowState extends State<CompactHabitRow> {
  bool _isPressed = false;

  (Color bg, Color iconTint) _getPastelPair(HabitFlowTokens tokens) {
    final cycle = (widget.habit.habit.colorValue >= 0 && widget.habit.habit.colorValue <= 3)
        ? widget.habit.habit.colorValue
        : widget.colorIndex % 4;
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

  String _goalText() {
    if (widget.habit.habit.description.trim().isNotEmpty) {
      return widget.habit.habit.description.trim();
    }
    switch (widget.habit.habit.frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.custom:
        return 'Custom';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isDone = widget.habit.isCompletedToday;
    final (pastelBg, pastelIconTint) = _getPastelPair(tokens);

    Widget content = Material(
      color: tokens.surface,
      shape: StadiumBorder(
        side: isDark
            ? BorderSide(color: tokens.border, width: 1)
            : BorderSide.none,
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
          left: 10.w,
          right: 12.w,
          top: 8.h,
          bottom: 8.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: isDark || isDone ? null : tokens.cardShadow,
        ),
        child: Row(
          children: [
            // 40px Circle Icon in pastel tone
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pastelBg,
              ),
              child: Center(
                child: widget.habit.habit.iconCodePoint != 0
                    ? (isEmojiCodePoint(widget.habit.habit.iconCodePoint)
                        ? Text(
                            String.fromCharCode(widget.habit.habit.iconCodePoint),
                            style: TextStyle(fontSize: 18.sp, height: 1),
                          )
                        : Icon(
                            IconData(
                              widget.habit.habit.iconCodePoint,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: pastelIconTint,
                            size: 20.sp,
                          ))
                    : Icon(
                        Icons.check_circle_outline_rounded,
                        color: pastelIconTint,
                        size: 20.sp,
                      ),
              ),
            ),

            SizedBox(width: 12.w),

            // Habit Name
            Expanded(
              child: Text(
                widget.habit.habit.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.urbanist(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: tokens.text,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  decorationColor: tokens.text.withValues(alpha: 0.6),
                ),
              ),
            ),

            SizedBox(width: 8.w),

            // Goal
            Text(
              _goalText(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: tokens.mutedText,
              ),
            ),

            SizedBox(width: 10.w),

            // 34px round check button with animated state
            Semantics(
              button: true,
              label: isDone
                  ? 'Undo ${widget.habit.habit.title}'
                  : 'Mark ${widget.habit.habit.title} as done',
              child: InkResponse(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onToggle();
                },
                radius: 22.r,
                splashColor: tokens.accent.withValues(alpha: 0.2),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44.r,
                    minHeight: 44.r,
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 230),
                      curve: Curves.easeOutCubic,
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? tokens.accent : Colors.transparent,
                        border: isDone
                            ? null
                            : Border.all(
                                color: tokens.mutedText.withValues(alpha: 0.6),
                                width: 1.75,
                              ),
                      ),
                      child: isDone
                          ? Icon(
                              Icons.check_rounded,
                              color: tokens.onAccent,
                              size: 18.sp,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Animate completion opacity
    content = AnimatedOpacity(
      opacity: isDone ? 0.60 : 1.0,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      child: content,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: content,
      ),
    );
  }
}
