import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../controllers/habits/habits_state.dart';
import 'progress_ring.dart';
import 'streak_pill.dart';
import 'week_indicator.dart';

const _monthAbbr = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const _weekdayFull = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday',
  'Friday', 'Saturday', 'Sunday',
];

DateTime _mondayOf(DateTime day) =>
    DateTime(day.year, day.month, day.day)
        .subtract(Duration(days: day.weekday - 1));

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Merged compact progress card — matches the reference image layout exactly.
/// Layout:
///   [ Ring ] [ Title (small)               ]
///            [ done / total  habits done   ]
///            [ "N left" chip  streak pill  ]
///   [────────── week indicator ────────────]
class MainProgressCard extends StatefulWidget {
  final HabitsState habitsState;
  final ValueNotifier<DateTime> selectedDayNotifier;

  const MainProgressCard({
    super.key,
    required this.habitsState,
    required this.selectedDayNotifier,
  });

  @override
  State<MainProgressCard> createState() => _MainProgressCardState();
}

class _MainProgressCardState extends State<MainProgressCard> {
  late DateTime _selectedDay;
  late final DateTime _today;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDay = _today;
  }

  bool get _isTodaySelected => _isSameDay(_selectedDay, _today);

  List<WeekDayData> _buildWeekDays(HabitsLoaded loaded) {
    final monday = _mondayOf(_today);
    final weekProgress = loaded.weekProgress;

    return List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      if (_isSameDay(date, _today)) {
        return WeekDayData(
          date: date,
          doneCount: loaded.completedToday,
          totalCount: loaded.totalHabits,
        );
      }
      final isFuture = date.isAfter(_today);
      if (isFuture) {
        return WeekDayData(date: date, doneCount: 0, totalCount: 0);
      }
      final dayIdx = date.weekday - 1;
      final done =
          dayIdx < weekProgress.length && weekProgress[dayIdx] ? 1 : 0;
      return WeekDayData(date: date, doneCount: done, totalCount: 1);
    });
  }

  ({int done, int total}) _statsForSelected(HabitsLoaded loaded) {
    if (_isTodaySelected) {
      return (done: loaded.completedToday, total: loaded.totalHabits);
    }
    final dayIdx = _selectedDay.weekday - 1;
    final wasCompleted =
        dayIdx < loaded.weekProgress.length && loaded.weekProgress[dayIdx];
    return (done: wasCompleted ? 1 : 0, total: 1);
  }

  String _cardTitle() {
    if (_isTodaySelected) return "Today's progress";
    return _weekdayFull[_selectedDay.weekday - 1];
  }

  /// Only shown for past days as a subtle sub-label.
  String? _cardSubtitle() {
    if (_isTodaySelected) return null;
    final mon = _monthAbbr[_selectedDay.month - 1];
    return '$mon ${_selectedDay.day} · past day';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final state = widget.habitsState;
    final HabitsLoaded? loaded = state is HabitsLoaded ? state : null;

    final stats = loaded != null ? _statsForSelected(loaded) : (done: 0, total: 0);
    final int done = stats.done;
    final int total = stats.total;
    final int streak = loaded?.currentStreak ?? 0;

    final double progress = total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0);
    final bool allDone = total > 0 && done >= total;
    final int remaining = (total - done).clamp(0, total);

    final weekDays = loaded != null
        ? _buildWeekDays(loaded)
        : List.generate(
            7,
            (i) => WeekDayData(
              date: _mondayOf(_today).add(Duration(days: i)),
              doneCount: 0,
              totalCount: 0,
            ),
          );

    final subtitle = _cardSubtitle();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: tokens.tileLavender,
        borderRadius: BorderRadius.circular(28.r),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Main content row: [Ring | Stats column] ──────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: progress ring (88px — compact)
                ProgressRing(
                  progress: progress,
                  percentage: (progress * 100).round(),
                  size: 90.r,
                ),

                SizedBox(width: 14.w),

                // Right: title + count + chips
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title: "Today's progress" / weekday name
                      Text(
                        _cardTitle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: tokens.text.withValues(alpha: 0.70),
                          height: 1.2,
                        ),
                      ),

                      // Past day subtitle
                      if (subtitle != null) ...[
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: tokens.text.withValues(alpha: 0.50),
                            height: 1.2,
                          ),
                        ),
                      ],

                      SizedBox(height: 2.h),

                      // Count row: "{done}  / {total}  habits done"
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$done',
                              style: GoogleFonts.urbanist(
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                                color: tokens.text,
                                height: 1.05,
                              ),
                            ),
                            Text(
                              ' / $total ',
                              style: GoogleFonts.urbanist(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                color: tokens.text.withValues(alpha: 0.55),
                                height: 1.05,
                              ),
                            ),
                            Text(
                              'habits done',
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: tokens.text.withValues(alpha: 0.65),
                                height: 1.05,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Chips row: [status chip] [streak pill]
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 6.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _StatusChip(
                            remaining: remaining,
                            allDone: allDone,
                            isPastDay: !_isTodaySelected,
                          ),
                          StreakPill(streak: streak),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // ── Week indicator ────────────────────────────────────────────
          WeekIndicator(
            days: weekDays,
            selectedDate: _selectedDay,
            today: _today,
            onDayTap: (date) {
              if (_isSameDay(date, _selectedDay)) return;
              setState(() => _selectedDay = date);
              widget.selectedDayNotifier.value = date;
            },
          ),
        ],
      ),
    );
  }
}

// ── Status chip ───────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final int remaining;
  final bool allDone;
  final bool isPastDay;

  const _StatusChip({
    required this.remaining,
    required this.allDone,
    required this.isPastDay,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipColor =
        tokens.raised.withValues(alpha: isDark ? 0.30 : 0.60);

    final String label;
    if (allDone) {
      label = 'Perfect day';
    } else if (isPastDay) {
      label = '$remaining missed';
    } else {
      label = '$remaining left';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
      decoration: ShapeDecoration(
        color: chipColor,
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.urbanist(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: tokens.text,
          height: 1.2,
        ),
      ),
    );
  }
}
