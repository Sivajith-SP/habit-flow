import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_radius.dart';
import '../../../models/habit/habit_frequency.dart';
import '../../../models/habit/habit_with_completion.dart';
import 'create_habit/icon_cell.dart';

class HabitCard extends StatefulWidget {
  final HabitWithCompletion habit;
  final int colorIndex;
  final VoidCallback onToggle;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final bool isSelected;

  const HabitCard({
    super.key,
    required this.habit,
    required this.colorIndex,
    required this.onToggle,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.isSelected = false,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool _isPressed = false;

  (Color bg, Color iconTint) _getPastelPair(HabitFlowTokens tokens) {
    // Cycling mint, pink, butter, lavender, honoring habit colorValue if valid tone
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

  String _subtitle() {
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

    Widget cardContent = Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: isDark || isDone ? null : tokens.cardShadow,
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      child: Row(
        children: [
          // 52px Icon Tile (20px radius)
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: pastelBg,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Center(
              child: widget.habit.habit.iconCodePoint != 0
                  ? (isEmojiCodePoint(widget.habit.habit.iconCodePoint)
                      ? Text(
                          String.fromCharCode(widget.habit.habit.iconCodePoint),
                          style: TextStyle(fontSize: 24.sp, height: 1),
                        )
                      : Icon(
                          IconData(
                            widget.habit.habit.iconCodePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: pastelIconTint,
                          size: 26.sp,
                        ))
                  : Icon(
                      Icons.check_circle_outline_rounded,
                      color: pastelIconTint,
                      size: 26.sp,
                    ),
            ),
          ),

          SizedBox(width: 14.w),

          // Habit Title + Subtitle/Goal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.habit.habit.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppUrbanist.habitName(
                    color: tokens.text,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  _subtitle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppUrbanist.body(
                    color: tokens.mutedText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // 40px Round Check Button
          Semantics(
            button: true,
            label: isDone ? 'Mark habit uncompleted' : 'Mark habit completed',
            child: InkResponse(
              onTap: widget.onToggle,
              radius: 24.r,
              splashColor: tokens.accent.withValues(alpha: 0.2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: 40.r,
                height: 40.r,
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
                    ? Center(
                        child: Icon(
                          Icons.check_rounded,
                          color: tokens.onAccent,
                          size: 22.sp,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );

    // Animate completion opacity
    cardContent = AnimatedOpacity(
      opacity: isDone ? 0.60 : 1.0,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      child: cardContent,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: cardContent,
      ),
    );
  }
}
