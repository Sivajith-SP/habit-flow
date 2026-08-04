import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitflow/models/habit/habit_with_completion.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../controllers/habits/habits_bloc.dart';
import '../../../controllers/habits/habits_event.dart';
import '../../../models/habit/habit_model.dart';
import 'habit_card.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Today's Habits",
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text(
                "See All",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: AppSpacing.md),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final habit = habits[index];

            return Dismissible(
              key: ValueKey(habit.habit.id),

              background: _archiveBackground(),

              secondaryBackground: _deleteBackground(),

              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  // Archive
                  return true;
                }

                return await _showDeleteDialog(context);
              },

              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  // TODO: ArchiveHabit event
                  context.read<HabitsBloc>().add(ArchiveHabit(habit.habit.id));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Habit archived"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  // TODO: DeleteHabit event
                  context.read<HabitsBloc>().add(DeleteHabit(habit.habit.id));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Habit deleted"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },

              child: HabitCard(
                habit: habit,
                isSelected: selectedHabitId == habit.habit.id,
                onTap: () => onHabitTap(habit.habit),
                onLongPress: () => onHabitLongPress(habit.habit),
                onEdit: () => onEditHabit(habit.habit),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _archiveBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.archive_outlined, color: Colors.white),
          SizedBox(width: 8),
          Text(
            "Archive",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.delete_outline, color: Colors.white),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete Habit?"),
            content: const Text("This action cannot be undone."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
