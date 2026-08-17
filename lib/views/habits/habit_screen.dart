import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habitflow/views/habits/widgets/habit_filter.dart';
import 'package:habitflow/views/habits/widgets/habit_filter_chips.dart';
import 'package:habitflow/views/habits/widgets/habit_management_card.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/habits/habits_bloc.dart';
import '../../controllers/habits/habits_event.dart';
import '../../controllers/habits/habits_state.dart';
import '../../models/habit/habit_frequency.dart';
import '../../models/habit/habit_with_completion.dart';
import '../dashboard/widgets/add_habit_bottom_sheet.dart';
import 'widgets/habit_search_bar.dart';
import 'widgets/habits_loading_state.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  HabitFilter _selectedFilter = HabitFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final listBottomPad = systemBottom + 100.h;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // ── Header ──────────────────────────────────────────
            _HabitsHeader(selectedFilter: _selectedFilter),

            SizedBox(height: 20.h),

            // ── Search Bar ──────────────────────────────────────
            HabitSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),

            SizedBox(height: AppSpacing.md),

            // ── Filter Chips ────────────────────────────────────
            HabitFilterChips(
              selected: _selectedFilter,
              onSelected: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),

            SizedBox(height: AppSpacing.lg),

            // ── Habit List ──────────────────────────────────────
            Expanded(
              child: BlocBuilder<HabitsBloc, HabitsState>(
                builder: (context, state) {
                  if (state is HabitsLoading) {
                    return const HabitsLoadingState();
                  }

                  if (state is HabitsError) {
                    return _ErrorState(message: state.message);
                  }

                  if (state is HabitsLoaded) {
                    final filteredHabits = state.habits.where((habit) {
                      final model = habit.habit;

                      final matchesFilter = switch (_selectedFilter) {
                        HabitFilter.all => !model.isArchived,
                        HabitFilter.daily =>
                          !model.isArchived &&
                              model.frequency == HabitFrequency.daily,
                        HabitFilter.weekly =>
                          !model.isArchived &&
                              model.frequency == HabitFrequency.weekly,
                        HabitFilter.custom =>
                          !model.isArchived &&
                              model.frequency == HabitFrequency.custom,
                        HabitFilter.archived => model.isArchived,
                      };

                      if (!matchesFilter) return false;

                      if (_searchQuery.isEmpty) return true;

                      return model.title
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          model.description
                              .toLowerCase()
                              .contains(_searchQuery);
                    }).toList();

                    if (filteredHabits.isEmpty) {
                      return _EmptyFilterState(filter: _selectedFilter);
                    }

                    if (_selectedFilter == HabitFilter.all) {
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: listBottomPad),
                        children: [
                          _buildSection(
                            context: context,
                            title: 'Daily',
                            icon: Icons.repeat_rounded,
                            habits: filteredHabits
                                .where(
                                  (h) =>
                                      h.habit.frequency ==
                                      HabitFrequency.daily,
                                )
                                .toList(),
                            listBottomPad: listBottomPad,
                          ),
                          _buildSection(
                            context: context,
                            title: 'Weekly',
                            icon: Icons.date_range_rounded,
                            habits: filteredHabits
                                .where(
                                  (h) =>
                                      h.habit.frequency ==
                                      HabitFrequency.weekly,
                                )
                                .toList(),
                            listBottomPad: listBottomPad,
                          ),
                          _buildSection(
                            context: context,
                            title: 'Custom',
                            icon: Icons.tune_rounded,
                            habits: filteredHabits
                                .where(
                                  (h) =>
                                      h.habit.frequency ==
                                      HabitFrequency.custom,
                                )
                                .toList(),
                            listBottomPad: listBottomPad,
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: listBottomPad),
                      itemCount: filteredHabits.length,
                      separatorBuilder: (_, i) =>
                          SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final habit = filteredHabits[index];
                        return _buildCard(context, habit);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<HabitWithCompletion> habits,
    required double listBottomPad,
  }) {
    if (habits.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header — matches todays_habits_section style
          Row(
            children: [
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 16.sp),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${habits.length}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          ...habits.map(
            (habit) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildCard(context, habit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, HabitWithCompletion habit) {
    return HabitManagementCard(
      habit: habit,
      onTap: () {},
      onEdit: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: context.read<HabitsBloc>(),
            child: AddHabitBottomSheet(habit: habit.habit),
          ),
        );
      },
      onArchive: () {
        if (habit.habit.isArchived) {
          context.read<HabitsBloc>().add(RestoreHabit(habit.habit.id));
        } else {
          context.read<HabitsBloc>().add(ArchiveHabit(habit.habit.id));
        }
      },
      onDelete: () async {
        final confirmed = await _showDeleteDialog(context, habit.habit.title);
        if (confirmed == true && context.mounted) {
          context.read<HabitsBloc>().add(DeleteHabit(habit.habit.id));
        }
      },
    );
  }

  Future<bool?> _showDeleteDialog(
    BuildContext context,
    String habitTitle,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.error,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Delete Habit?',
                style: AppTextStyles.heading2.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Are you sure you want to delete "$habitTitle"?\nThis action cannot be undone.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Delete',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header — matches DashboardHeader pattern
// ─────────────────────────────────────────────────────────────────────────────

class _HabitsHeader extends StatelessWidget {
  final HabitFilter selectedFilter;

  const _HabitsHeader({required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habits',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.15,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Manage & track all your habits',
          style: AppTextStyles.body.copyWith(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error State — themed to match design system
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 32.sp,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Something went wrong',
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty Filter State — themed to match EmptyHabitsState
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyFilterState extends StatelessWidget {
  final HabitFilter filter;

  const _EmptyFilterState({required this.filter});

  String get _message => switch (filter) {
    HabitFilter.all => "You haven't created any habits yet.\nTap + to get started.",
    HabitFilter.daily => "No daily habits found.",
    HabitFilter.weekly => "No weekly habits found.",
    HabitFilter.custom => "No custom habits found.",
    HabitFilter.archived => "No archived habits yet.\nArchived habits will appear here.",
  };

  IconData get _icon => switch (filter) {
    HabitFilter.archived => Icons.archive_outlined,
    _ => Icons.task_alt_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72.r,
                      height: 72.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _icon,
                        color: AppColors.primary,
                        size: 36.sp,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text(
                      _message,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
