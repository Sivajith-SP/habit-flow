import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_flow_tokens.dart';
import '../../../../controllers/habits/habits_bloc.dart';
import '../../../../controllers/habits/habits_event.dart';
import '../../../../models/habit/habit_frequency.dart';
import '../../../../models/habit/habit_model.dart';
import 'days_cell.dart';
import 'icon_cell.dart';
import 'name_cell.dart';
import 'repeat_cell.dart';
import 'save_habit_button.dart';

// ---------------------------------------------------------------------------
// Shared staggered-reveal helper used by CreateHabitSheet bento items
// ---------------------------------------------------------------------------

/// Fades and slides a [child] in after [delay], over [duration].
class _StaggeredReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const _StaggeredReveal({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 360),
  });

  @override
  State<_StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<_StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
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



/// CreateHabitSheet provides the full bento-grid habit creation & editing experience.
class CreateHabitSheet extends StatefulWidget {
  final HabitModel? habit;

  const CreateHabitSheet({super.key, this.habit});

  /// Opens the Create Habit bottom sheet with full configuration.
  static Future<T?> show<T>(BuildContext context, {HabitModel? habit}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final habitsBloc = context.read<HabitsBloc>();

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: isDark
          ? Colors.black.withValues(alpha: 0.60)
          : Colors.black.withValues(alpha: 0.42),
      builder: (_) => BlocProvider.value(
        value: habitsBloc,
        child: CreateHabitSheet(habit: habit),
      ),
    );
  }

  @override
  State<CreateHabitSheet> createState() => _CreateHabitSheetState();
}

class _CreateHabitSheetState extends State<CreateHabitSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();

  late IconData _selectedIcon;
  late int _selectedTone; // 0: mint, 1: pink, 2: butter, 3: lavender
  late HabitFrequency _frequency;
  late Set<int> _selectedDays;

  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();

    final habit = widget.habit;
    if (habit != null) {
      _nameController = TextEditingController(text: habit.title);
      _noteController = TextEditingController(text: habit.description);
      _selectedIcon = IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons');
      _selectedTone = (habit.colorValue >= 0 && habit.colorValue <= 3)
          ? habit.colorValue
          : 0;
      _frequency = habit.frequency;
      if (_frequency == HabitFrequency.daily) {
        _selectedDays = {1, 2, 3, 4, 5, 6, 7};
      } else if (habit.targetDays.contains(0)) {
        // Migrate legacy 0-indexed (0=Mon..6=Sun) to 1..7
        _selectedDays = habit.targetDays.map((d) => d + 1).toSet();
      } else {
        _selectedDays = Set<int>.from(habit.targetDays);
      }
    } else {
      _nameController = TextEditingController();
      _noteController = TextEditingController();
      _selectedIcon = Icons.water_drop_outlined;
      _selectedTone = 0; // mint default
      _frequency = HabitFrequency.daily;
      _selectedDays = {1, 2, 3, 4, 5, 6, 7}; // all 7 days
    }

    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _nameFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _onFrequencyChanged(HabitFrequency newFrequency) {
    if (_frequency == newFrequency) return;

    setState(() {
      final prevFrequency = _frequency;
      _frequency = newFrequency;

      final todayWeekday = DateTime.now().weekday; // 1 = Mon .. 7 = Sun

      if (newFrequency == HabitFrequency.daily) {
        // Any option to Daily selects all 7
        _selectedDays = {1, 2, 3, 4, 5, 6, 7};
      } else if (prevFrequency == HabitFrequency.daily) {
        // Daily to Weekly or Custom preselects today's weekday
        _selectedDays = {todayWeekday};
      } else if (prevFrequency == HabitFrequency.weekly &&
          newFrequency == HabitFrequency.custom) {
        // Weekly to Custom keeps the selected day
        // _selectedDays is already {selectedDay}
      } else if (prevFrequency == HabitFrequency.custom &&
          newFrequency == HabitFrequency.weekly) {
        // Custom to Weekly keeps only the earliest selected day
        if (_selectedDays.isNotEmpty) {
          final earliestDay = (_selectedDays.toList()..sort()).first;
          _selectedDays = {earliestDay};
        } else {
          _selectedDays = {todayWeekday};
        }
      }
    });
  }

  void _onDayToggled(int day) {
    if (_frequency == HabitFrequency.daily) return;

    setState(() {
      if (_frequency == HabitFrequency.weekly) {
        // Weekly: single-select mode. Tapping replaces selection, cannot be deselected.
        _selectedDays = {day};
      } else if (_frequency == HabitFrequency.custom) {
        // Custom: multi-select mode. Tapping toggles a day.
        if (_selectedDays.contains(day)) {
          _selectedDays.remove(day);
        } else {
          _selectedDays.add(day);
        }
      }
    });
  }

  bool get _isSaveEnabled {
    final trimmed = _nameController.text.trim();
    if (trimmed.isEmpty) return false;
    if (_frequency == HabitFrequency.daily) return true;
    return _selectedDays.isNotEmpty;
  }

  void _saveHabit() {
    if (!_isSaveEnabled) return;

    final now = DateTime.now();
    final name = _nameController.text.trim();
    final note = _noteController.text.trim();
    final isEditing = widget.habit != null;

    final sortedDays = _selectedDays.toList()..sort();

    if (!isEditing) {
      final newHabit = HabitModel(
        id: _uuid.v4(),
        title: name,
        description: note,
        iconCodePoint: _selectedIcon.codePoint,
        colorValue: _selectedTone,
        frequency: _frequency,
        targetDays: sortedDays,
        reminderMinutes: null,
        createdAt: now,
        updatedAt: now,
      );

      context.read<HabitsBloc>().add(AddHabit(newHabit));
    } else {
      final updatedHabit = widget.habit!.copyWith(
        title: name,
        description: note,
        iconCodePoint: _selectedIcon.codePoint,
        colorValue: _selectedTone,
        frequency: _frequency,
        targetDays: sortedDays,
        updatedAt: now,
      );

      context.read<HabitsBloc>().add(UpdateHabit(updatedHabit));
    }

    Navigator.of(context).pop();

    // Show floating pill SnackBar
    final tokens = context.flowTokens;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tokens.ink,
        shape: const StadiumBorder(),
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(seconds: 2),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: tokens.onInk,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isEditing ? 'Habit updated' : 'Habit added',
              style: AppUrbanist.snackBar(color: tokens.onInk),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.habit != null;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.94),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 12),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: tokens.hairline,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header: Title + Round Close Button
                      _StaggeredReveal(
                        delay: Duration.zero,
                        duration: const Duration(milliseconds: 280),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEditing ? 'Edit habit' : 'New habit',
                              style: AppUrbanist.sheetTitle(color: tokens.text),
                            ),
                            Semantics(
                              label: 'Close',
                              button: true,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: tokens.field,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                    color: tokens.text,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Bento grid: 2-column grid with 10px gaps
                      // A. Name Tile (full width)
                      _StaggeredReveal(
                        delay: const Duration(milliseconds: 60),
                        child: NameCell(
                          titleController: _nameController,
                          noteController: _noteController,
                          titleFocusNode: _nameFocusNode,
                          noteFocusNode: _noteFocusNode,
                          onTitleChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // B. Icon Tile (full width)
                      _StaggeredReveal(
                        delay: const Duration(milliseconds: 110),
                        child: IconCell(
                          selectedTone: _selectedTone,
                          selectedIcon: _selectedIcon,
                          onToneSelected: (tone) => setState(() => _selectedTone = tone),
                          onIconSelected: (icon) => setState(() => _selectedIcon = icon),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // C & D. Repeat and Days half tiles in IntrinsicHeight
                      _StaggeredReveal(
                        delay: const Duration(milliseconds: 160),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: RepeatCell(
                                  frequency: _frequency,
                                  onFrequencyChanged: _onFrequencyChanged,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DaysCell(
                                  frequency: _frequency,
                                  selectedDays: _selectedDays,
                                  onDayToggled: _onDayToggled,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Save Button (56px StadiumBorder)
                      _StaggeredReveal(
                        delay: const Duration(milliseconds: 210),
                        child: SaveHabitButton(
                          isEnabled: _isSaveEnabled,
                          onSave: _saveHabit,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
