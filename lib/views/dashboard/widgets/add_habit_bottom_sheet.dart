import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
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
      final habit = HabitModel(
        id: _uuid.v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        iconCodePoint: _selectedIcon.codePoint,
        colorValue: Colors.blue.toARGB32(),
        frequency: _frequency,
        targetDays: List.from(_selectedDays),
        reminderMinutes: null,
        createdAt: now,
        updatedAt: now,
      );

      context.read<HabitsBloc>().add(AddHabit(habit));
    } else {
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Drag Handle
                  Center(
                    child: Container(
                      width: 38.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.habit == null ? "Create Habit" : "Edit Habit",
                        style: AppTextStyles.heading2.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColors.textMuted,
                          size: 22.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.md),

                  // Habit Name Input
                  TextFormField(
                    controller: _titleController,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: "Habit Name",
                      hintText: "e.g. Drink 2L Water",
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      filled: true,
                      fillColor: AppColors.background.withValues(alpha: 0.5),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.border.withValues(alpha: 0.4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Habit name is required";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: AppSpacing.md),

                  // Description Input
                  TextFormField(
                    controller: _descriptionController,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: "Description (Optional)",
                      hintText: "Add a gentle note or target",
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      filled: true,
                      fillColor: AppColors.background.withValues(alpha: 0.5),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide(
                          color: AppColors.border.withValues(alpha: 0.4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    maxLines: 2,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Choose Icon Section
                  Text(
                    "Choose Icon",
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),

                  SizedBox(
                    height: 52.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _icons.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final icon = _icons[index];
                        final selected = icon == _selectedIcon;

                        return InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.background.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border.withValues(alpha: 0.3),
                              ),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              icon,
                              size: 22.sp,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Frequency Selector Section
                  Text(
                    "Frequency",
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),

                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      children: [
                        _buildFrequencyTab(
                          label: "Daily",
                          value: HabitFrequency.daily,
                        ),
                        _buildFrequencyTab(
                          label: "Weekly",
                          value: HabitFrequency.weekly,
                        ),
                        _buildFrequencyTab(
                          label: "Custom",
                          value: HabitFrequency.custom,
                        ),
                      ],
                    ),
                  ),

                  if (_frequency == HabitFrequency.custom) ...[
                    SizedBox(height: AppSpacing.lg),

                    Text(
                      "Choose Days",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: AppSpacing.sm),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        const days = ["M", "T", "W", "T", "F", "S", "S"];
                        final selected = _selectedDays.contains(index);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selectedDays.remove(index);
                              } else {
                                _selectedDays.add(index);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.background.withValues(alpha: 0.6),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                days[index],
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],

                  SizedBox(height: AppSpacing.xl),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: AppSpacing.buttonHeight,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _saveHabit,
                      child: Text(
                        widget.habit == null ? "Save Habit" : "Update Habit",
                        style: AppTextStyles.button.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyTab({
    required String label,
    required HabitFrequency value,
  }) {
    final selected = _frequency == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _frequency = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
