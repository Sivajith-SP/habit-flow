import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../controllers/habits/habits_bloc.dart';
import '../../../controllers/habits/habits_event.dart';
import '../../../models/habit/habit_frequency.dart';
import '../../../models/habit/habit_model.dart';

class AddHabitBottomSheet extends StatefulWidget {
  final HabitModel? habit;

  const AddHabitBottomSheet({super.key, this.habit});

  @override
  State<AddHabitBottomSheet> createState() => _AddHabitBottomSheetState();
}

class _AddHabitBottomSheetState extends State<AddHabitBottomSheet> {
  HabitFrequency _frequency = HabitFrequency.daily;
  final List<int> _selectedDays = [];
  IconData _selectedIcon = Icons.water_drop;

  final List<IconData> _icons = [
    Icons.water_drop,
    Icons.local_drink,
    Icons.directions_run,
    Icons.directions_walk,
    Icons.fitness_center,
    Icons.self_improvement,
    Icons.menu_book,
    Icons.school,
    Icons.code,
    Icons.bedtime,
    Icons.spa,
    Icons.restaurant,
    Icons.apple,
    Icons.medication,
    Icons.music_note,
    Icons.directions_bike,
  ];

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();

    if (widget.habit != null) {
      _titleController.text = widget.habit!.title;
      _descriptionController.text = widget.habit!.description;

      _frequency = widget.habit!.frequency;

      _selectedDays
        ..clear()
        ..addAll(widget.habit!.targetDays);
      _selectedIcon = IconData(
        widget.habit!.iconCodePoint,
        fontFamily: 'MaterialIcons',
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();

    if (widget.habit == null) {
      /// CREATE
      final habit = HabitModel(
        id: _uuid.v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        iconCodePoint: _selectedIcon.codePoint,
        colorValue: Colors.blue.value,
        frequency: _frequency,
        targetDays: List.from(_selectedDays),
        reminderMinutes: null,
        createdAt: now,
        updatedAt: now,
      );

      context.read<HabitsBloc>().add(AddHabit(habit));
    } else {
      /// UPDATE
      final updatedHabit = widget.habit!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        iconCodePoint: _selectedIcon.codePoint,
        frequency: _frequency,
        targetDays: List.from(_selectedDays),
        updatedAt: now,
      );

      context.read<HabitsBloc>().add(UpdateHabit(updatedHabit));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.habit == null ? "Create Habit" : "Edit Habit",
                style: AppTextStyles.heading2,
              ),

              SizedBox(height: AppSpacing.xl),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Habit Name",
                  hintText: "Drink 2L Water",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Habit name is required";
                  }
                  return null;
                },
              ),

              SizedBox(height: AppSpacing.lg),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "Optional",
                ),
                maxLines: 3,
              ),

              SizedBox(height: AppSpacing.lg),

              Text(
                "Choose Icon",
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: AppSpacing.sm),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _icons.map((icon) {
                  final selected = icon == _selectedIcon;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: selected
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: AppSpacing.lg),

              Text(
                "Frequency",
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: AppSpacing.sm),

              SegmentedButton<HabitFrequency>(
                segments: const [
                  ButtonSegment(
                    value: HabitFrequency.daily,
                    label: Text("Daily"),
                  ),
                  ButtonSegment(
                    value: HabitFrequency.weekly,
                    label: Text("Weekly"),
                  ),
                  ButtonSegment(
                    value: HabitFrequency.custom,
                    label: Text("Custom"),
                  ),
                ],
                selected: {_frequency},
                onSelectionChanged: (value) {
                  setState(() {
                    _frequency = value.first;
                  });
                },
              ),
              if (_frequency == HabitFrequency.custom) ...[
                SizedBox(height: AppSpacing.lg),

                Text(
                  "Choose Days",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                Wrap(
                  spacing: 8,
                  children: List.generate(7, (index) {
                    const days = [
                      "Mon",
                      "Tue",
                      "Wed",
                      "Thu",
                      "Fri",
                      "Sat",
                      "Sun",
                    ];

                    final selected = _selectedDays.contains(index);

                    return FilterChip(
                      label: Text(days[index]),
                      selected: selected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedDays.add(index);
                          } else {
                            _selectedDays.remove(index);
                          }
                        });
                      },
                    );
                  }),
                ),
              ],
              SizedBox(height: AppSpacing.xl),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveHabit,
                  child: Text(
                    widget.habit == null ? "Save Habit" : "Update Habit",
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
