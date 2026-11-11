import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../controllers/habits/habits_bloc.dart';
import '../../controllers/habits/habits_event.dart';
import '../../controllers/habits/habits_state.dart';
import '../../models/habit/habit_frequency.dart';
import '../../models/habit/habit_with_completion.dart';
import '../common/frosted_scroll_header.dart';
import '../dashboard/widgets/add_habit_bottom_sheet.dart';
import 'widgets/habit_filter.dart';
import 'widgets/habit_filter_chips.dart';
import 'widgets/habit_management_card.dart';
import 'widgets/habit_search_bar.dart';
import 'widgets/habits_loading_state.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _searchAnimController;

  String _searchQuery = '';
  HabitFilter _selectedFilter = HabitFilter.all;

  bool _isSearchVisible = true;
  double _lastScrollOffset = 0.0;
  double _accumulatedDelta = 0.0;

  @override
  void initState() {
    super.initState();
    _searchAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
      value: 1.0,
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    // Keep search bar visible while actively filtering by query
    if (_searchQuery.isNotEmpty) return;

    final position = _scrollController.position;
    final currentOffset = position.pixels;
    final delta = currentOffset - _lastScrollOffset;
    _lastScrollOffset = currentOffset;

    // 1. When near the top: always restore search bar smoothly
    if (currentOffset <= 12.0) {
      _accumulatedDelta = 0.0;
      if (!_isSearchVisible) {
        _isSearchVisible = true;
        _searchAnimController.duration = const Duration(milliseconds: 400);
        _searchAnimController.forward();
      }
      return;
    }

    // 2. Ignore boundary overscroll rebounds (rubber-banding at bottom or top)
    if (currentOffset > position.maxScrollExtent || currentOffset < 0) {
      return;
    }

    final direction = position.userScrollDirection;

    // 3. Direction change: reset accumulated delta
    if ((delta > 0 && _accumulatedDelta < 0) ||
        (delta < 0 && _accumulatedDelta > 0)) {
      _accumulatedDelta = 0.0;
    }
    _accumulatedDelta += delta;

    // 4. Downward scroll: hide search bar
    // Works reliably on both fast flick (large instant delta) and slow drag
    final isDownwardScroll = direction == ScrollDirection.reverse ||
        (direction == ScrollDirection.idle && delta > 0);

    if (isDownwardScroll && _isSearchVisible) {
      final isFastScroll = delta > 25.0 || _accumulatedDelta > 40.0;
      if (delta > 15.0 || _accumulatedDelta > 16.0) {
        _isSearchVisible = false;
        _searchAnimController.duration = Duration(
          milliseconds: isFastScroll ? 260 : 480,
        );
        _searchAnimController.reverse();
        _accumulatedDelta = 0.0;
      }
    }
    // 5. Upward scroll: only restore when user is deliberately dragging upward
    else if (direction == ScrollDirection.forward && !_isSearchVisible) {
      if (_accumulatedDelta < -15.0) {
        _isSearchVisible = true;
        _searchAnimController.duration = const Duration(milliseconds: 380);
        _searchAnimController.forward();
        _accumulatedDelta = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchAnimController.dispose();
    super.dispose();
  }

  Widget _buildDivider(bool isDark, HabitFlowTokens tokens) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 76.w,
      endIndent: AppSpacing.md,
      color: isDark
          ? tokens.border.withValues(alpha: 0.5)
          : const Color(0xFFF0EDF6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final listBottomPad = systemBottom + 120.h;

    // Header metrics:
    // top gap: 14.h
    // title/subtitle: ~52.h
    // gap: 14.h
    // search bar: ~52.h (or 0 when hidden)
    // gap: 12.h
    // filter chips: ~40.h
    // bottom gap: 14.h
    final headerContentHeight = 186.h;
    final listTopPadding = statusBarHeight + headerContentHeight + 8.h;

    Widget headerWidget = SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          14.h,
          AppSpacing.screenPadding,
          14.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header (Title + Subtitle) ──────────────────────────
            const _HabitsHeader(),

            SizedBox(height: 14.h),

            // ── Collapsible Search Bar (Slides and fades smoothly like X) ──
            SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: _searchAnimController,
                curve: Curves.easeInOutCubic,
              ),
              axisAlignment: -1.0,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _searchAnimController,
                  curve: const Interval(0.15, 1.0, curve: Curves.easeOutCubic),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.25),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _searchAnimController,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: HabitSearchBar(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim().toLowerCase();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ── Filter Chips ───────────────────────────────────────
            HabitFilterChips(
              selected: _selectedFilter,
              onSelected: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
          ],
        ),
      ),
    );

    return ColoredBox(
      color: tokens.background,
      child: Stack(
        children: [
          // ── Scrollable Body ──────────────────────────────────────────
          BlocBuilder<HabitsBloc, HabitsState>(
            builder: (context, state) {
              if (state is HabitsLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: listTopPadding),
                  child: const HabitsLoadingState(),
                );
              }

              if (state is HabitsError) {
                return Padding(
                  padding: EdgeInsets.only(top: listTopPadding),
                  child: _ErrorState(message: state.message),
                );
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

                  return model.title.toLowerCase().contains(_searchQuery) ||
                      model.description.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredHabits.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: listTopPadding),
                    child: _EmptyFilterState(filter: _selectedFilter),
                  );
                }

                if (_selectedFilter == HabitFilter.all) {
                  final dailyHabits = filteredHabits
                      .where((h) => h.habit.frequency == HabitFrequency.daily)
                      .toList();
                  final weeklyHabits = filteredHabits
                      .where((h) => h.habit.frequency == HabitFrequency.weekly)
                      .toList();
                  final customHabits = filteredHabits
                      .where((h) => h.habit.frequency == HabitFrequency.custom)
                      .toList();

                  return ListView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      listTopPadding,
                      AppSpacing.screenPadding,
                      listBottomPad,
                    ),
                    children: [
                      if (dailyHabits.isNotEmpty)
                        _buildGroupSection(
                          context: context,
                          title: 'Daily',
                          icon: Icons.repeat_rounded,
                          habits: dailyHabits,
                          tokens: tokens,
                          isDark: isDark,
                        ),
                      if (weeklyHabits.isNotEmpty)
                        _buildGroupSection(
                          context: context,
                          title: 'Weekly',
                          icon: Icons.date_range_rounded,
                          habits: weeklyHabits,
                          tokens: tokens,
                          isDark: isDark,
                        ),
                      if (customHabits.isNotEmpty)
                        _buildGroupSection(
                          context: context,
                          title: 'Custom',
                          icon: Icons.tune_rounded,
                          habits: customHabits,
                          tokens: tokens,
                          isDark: isDark,
                        ),
                    ],
                  );
                }

                // Specific filter selected: single grouped card
                final String sectionTitle = switch (_selectedFilter) {
                  HabitFilter.daily => 'Daily',
                  HabitFilter.weekly => 'Weekly',
                  HabitFilter.custom => 'Custom',
                  HabitFilter.archived => 'Archived',
                  HabitFilter.all => 'Habits',
                };

                final IconData sectionIcon = switch (_selectedFilter) {
                  HabitFilter.daily => Icons.repeat_rounded,
                  HabitFilter.weekly => Icons.date_range_rounded,
                  HabitFilter.custom => Icons.tune_rounded,
                  HabitFilter.archived => Icons.archive_outlined,
                  HabitFilter.all => Icons.task_alt_rounded,
                };

                return ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    listTopPadding,
                    AppSpacing.screenPadding,
                    listBottomPad,
                  ),
                  children: [
                    _buildGroupSection(
                      context: context,
                      title: sectionTitle,
                      icon: sectionIcon,
                      habits: filteredHabits,
                      tokens: tokens,
                      isDark: isDark,
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),

          // ── Frosted glass header overlay (Matches StatisticsScreen) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FrostedScrollHeader(
              controller: _scrollController,
              fadeStartOffset: 0,
              fadeEndOffset: 40,
              child: headerWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<HabitWithCompletion> habits,
    required HabitFlowTokens tokens,
    required bool isDark,
  }) {
    if (habits.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header matching design mockup
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
            child: Row(
              children: [
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: tokens.tileLavender,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    color: tokens.tileLavenderIcon,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: AppUrbanist.habitName(color: tokens.text),
                ),
                SizedBox(width: 10.w),
                Text(
                  '${habits.length}',
                  style: AppUrbanist.body(
                    color: tokens.mutedText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Grouped Card container matching reference mockup
          Container(
            decoration: BoxDecoration(
              color: isDark ? tokens.raised : tokens.surface,
              borderRadius: BorderRadius.circular(24.r),
              border: isDark ? Border.all(color: tokens.border, width: 1) : null,
              boxShadow: isDark ? null : tokens.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Column(
                children: [
                  for (int i = 0; i < habits.length; i++) ...[
                    HabitManagementCard(
                      habit: habits[i],
                      onTap: () {},
                      onEdit: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => BlocProvider.value(
                            value: context.read<HabitsBloc>(),
                            child: AddHabitBottomSheet(habit: habits[i].habit),
                          ),
                        );
                      },
                      onArchive: () {
                        if (habits[i].habit.isArchived) {
                          context
                              .read<HabitsBloc>()
                              .add(RestoreHabit(habits[i].habit.id));
                        } else {
                          context
                              .read<HabitsBloc>()
                              .add(ArchiveHabit(habits[i].habit.id));
                        }
                      },
                      onDelete: () async {
                        final confirmed = await _showDeleteDialog(
                          context,
                          habits[i].habit.title,
                        );
                        if (confirmed == true && context.mounted) {
                          context
                              .read<HabitsBloc>()
                              .add(DeleteHabit(habits[i].habit.id));
                        }
                      },
                    ),
                    if (i < habits.length - 1) _buildDivider(isDark, tokens),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteDialog(
    BuildContext context,
    String habitTitle,
  ) async {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          backgroundColor: isDark ? tokens.raised : tokens.surface,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDE3750).withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: const Color(0xFFDE3750),
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Delete Habit?',
                  style: AppUrbanist.sectionTitle(color: tokens.text)
                      .copyWith(fontSize: 18.sp),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Are you sure you want to delete "$habitTitle"?\nThis action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: AppUrbanist.body(
                    color: tokens.mutedText,
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
                            color: isDark ? tokens.border : tokens.hairline,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: Text(
                          'Cancel',
                          style: AppUrbanist.body(
                            color: tokens.text,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFDE3750),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: Text(
                          'Delete',
                          style: AppUrbanist.body(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header — matches DashboardHeader pattern & Reference Mockup
// ─────────────────────────────────────────────────────────────────────────────

class _HabitsHeader extends StatelessWidget {
  const _HabitsHeader();

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habits',
          style: AppUrbanist.greeting(color: tokens.text)
              .copyWith(fontSize: 28.sp),
        ),
        SizedBox(height: 3.h),
        Text(
          'Manage & track all your habits',
          style: AppUrbanist.body(
            color: tokens.mutedText,
            fontSize: 13.5.sp,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error State
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

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
                color: const Color(0xFFDE3750).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 32.sp,
                color: const Color(0xFFDE3750),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Something went wrong',
              style: AppUrbanist.sectionTitle(color: tokens.text)
                  .copyWith(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppUrbanist.body(
                color: tokens.mutedText,
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
// Empty Filter State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyFilterState extends StatelessWidget {
  final HabitFilter filter;

  const _EmptyFilterState({required this.filter});

  String get _message => switch (filter) {
    HabitFilter.all =>
      "You haven't created any habits yet.\nTap + to get started.",
    HabitFilter.daily => "No daily habits found.",
    HabitFilter.weekly => "No weekly habits found.",
    HabitFilter.custom => "No custom habits found.",
    HabitFilter.archived =>
      "No archived habits yet.\nArchived habits will appear here.",
  };

  IconData get _icon => switch (filter) {
    HabitFilter.archived => Icons.archive_outlined,
    _ => Icons.task_alt_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

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
                      decoration: BoxDecoration(
                        color: tokens.tileLavender,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _icon,
                        color: tokens.tileLavenderIcon,
                        size: 36.sp,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text(
                      _message,
                      style: AppUrbanist.body(
                        color: tokens.mutedText,
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
