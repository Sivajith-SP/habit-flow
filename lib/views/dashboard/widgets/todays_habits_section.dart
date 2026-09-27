import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../models/habit/habit_model.dart';
import '../../../models/habit/habit_with_completion.dart';
import 'all_done_card.dart';
import 'compact_habit_row.dart';
import 'section_divider.dart';
import 'up_next_card.dart';

// ---------------------------------------------------------------------------
// Lightweight stagger helper for list items
// ---------------------------------------------------------------------------

class _StaggeredListItem extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _StaggeredListItem({
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<_StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<_StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ---------------------------------------------------------------------------

class TodaysHabitsSection extends StatelessWidget {
  final List<HabitWithCompletion> habits;
  final ValueChanged<HabitModel> onHabitTap;
  final ValueChanged<HabitModel> onHabitLongPress;
  final ValueChanged<HabitModel> onEditHabit;
  final String? selectedHabitId;

  const TodaysHabitsSection({
    super.key,
    required this.habits,
    required this.onHabitTap,
    required this.onHabitLongPress,
    required this.onEditHabit,
    required this.selectedHabitId,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final bool disableAnimations = MediaQuery.disableAnimationsOf(context);

    final activeHabits = habits.where((h) => !h.isCompletedToday).toList();
    final completedHabits = habits.where((h) => h.isCompletedToday).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header: "Today's habits" (22 / w800) + "See all" (mutedText, w600)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Today's habits",
              style: GoogleFonts.urbanist(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: tokens.text,
              ),
            ),
            Semantics(
              button: true,
              label: 'See all habits',
              child: GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
                  child: Text(
                    'See all',
                    style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: tokens.mutedText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // A. Up Next Hero Card (or Empty State) with AnimatedSwitcher
        AnimatedSwitcher(
          duration: disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0.0, 0.08),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },
          child: activeHabits.isNotEmpty
              ? UpNextCard(
                  key: ValueKey('hero_${activeHabits.first.habit.id}'),
                  habit: activeHabits.first,
                  colorIndex: habits.indexOf(activeHabits.first),
                  onDone: () => onHabitTap(activeHabits.first.habit),
                )
              : AllDoneCard(
                  key: const ValueKey('hero_empty'),
                ),
        ),

        // B. Later Today (Remaining Pending Habits)
        if (activeHabits.length > 1) ...[
          SizedBox(height: 24.h),
          const SectionDivider(label: 'Later today'),
          SizedBox(height: 14.h),
          ...List.generate(activeHabits.length - 1, (index) {
            final habit = activeHabits[index + 1];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _StaggeredListItem(
                delay: Duration(milliseconds: 60 + index * 40),
                child: CompactHabitRow(
                  key: ValueKey('pending_${habit.habit.id}'),
                  habit: habit,
                  colorIndex: habits.indexOf(habit),
                  onToggle: () => onHabitTap(habit.habit),
                  onTap: () => onHabitTap(habit.habit),
                ),
              ),
            );
          }),
        ],

        // C. Completed Section
        if (completedHabits.isNotEmpty) ...[
          SizedBox(height: 24.h),
          SectionDivider(
            label: 'Completed · ${completedHabits.length}',
            icon: Icons.check_rounded,
          ),
          SizedBox(height: 14.h),
          ...List.generate(completedHabits.length, (index) {
            final habit = completedHabits[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _StaggeredListItem(
                delay: Duration(milliseconds: 40 + index * 40),
                child: CompactHabitRow(
                  key: ValueKey('completed_${habit.habit.id}'),
                  habit: habit,
                  colorIndex: habits.indexOf(habit),
                  onToggle: () => onHabitTap(habit.habit),
                  onTap: () => onHabitTap(habit.habit),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
