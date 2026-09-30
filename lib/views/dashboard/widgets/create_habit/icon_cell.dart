import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_flow_tokens.dart';
import 'bento_cell.dart';

/// IconItem pairs an [IconData] with its semantic label and category.
class HabitIconItem {
  final IconData icon;
  final String label;
  final String category;

  const HabitIconItem({
    required this.icon,
    required this.label,
    this.category = 'General',
  });
}

/// Essential habit-tracker icons shown in the primary quick-selection row.
const List<HabitIconItem> kHabitIcons = [
  HabitIconItem(icon: Icons.water_drop_outlined, label: 'Water', category: 'Health'),
  HabitIconItem(icon: Icons.local_drink_outlined, label: 'Drink', category: 'Health'),
  HabitIconItem(icon: Icons.directions_walk_rounded, label: 'Walk', category: 'Fitness'),
  HabitIconItem(icon: Icons.directions_run_rounded, label: 'Run', category: 'Fitness'),
  HabitIconItem(icon: Icons.fitness_center_rounded, label: 'Workout', category: 'Fitness'),
  HabitIconItem(icon: Icons.self_improvement_rounded, label: 'Meditate', category: 'Mind'),
  HabitIconItem(icon: Icons.menu_book_rounded, label: 'Read', category: 'Productivity'),
  HabitIconItem(icon: Icons.bedtime_outlined, label: 'Sleep', category: 'Health'),
  HabitIconItem(icon: Icons.restaurant_outlined, label: 'Food', category: 'Health'),
  HabitIconItem(icon: Icons.timer_outlined, label: 'Focus', category: 'Productivity'),
  HabitIconItem(icon: Icons.edit_note_rounded, label: 'Journal', category: 'Mind'),
  HabitIconItem(icon: Icons.favorite_border_rounded, label: 'Health', category: 'Health'),
  HabitIconItem(icon: Icons.savings_outlined, label: 'Savings', category: 'Productivity'),
  HabitIconItem(icon: Icons.wb_sunny_outlined, label: 'Morning', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.school_outlined, label: 'Study', category: 'Productivity'),
];

/// Comprehensive categorized icon catalog for custom icon selection.
const List<HabitIconItem> kAllHabitIcons = [
  // Fitness & Sport
  HabitIconItem(icon: Icons.fitness_center_rounded, label: 'Workout', category: 'Fitness'),
  HabitIconItem(icon: Icons.directions_run_rounded, label: 'Run', category: 'Fitness'),
  HabitIconItem(icon: Icons.directions_walk_rounded, label: 'Walk', category: 'Fitness'),
  HabitIconItem(icon: Icons.pedal_bike_rounded, label: 'Cycling', category: 'Fitness'),
  HabitIconItem(icon: Icons.pool_rounded, label: 'Swimming', category: 'Fitness'),
  HabitIconItem(icon: Icons.hiking_rounded, label: 'Hiking', category: 'Fitness'),
  HabitIconItem(icon: Icons.sports_gymnastics_rounded, label: 'Gymnastics', category: 'Fitness'),
  HabitIconItem(icon: Icons.sports_basketball_rounded, label: 'Basketball', category: 'Fitness'),
  HabitIconItem(icon: Icons.sports_soccer_rounded, label: 'Soccer', category: 'Fitness'),
  HabitIconItem(icon: Icons.sports_tennis_rounded, label: 'Tennis', category: 'Fitness'),
  HabitIconItem(icon: Icons.sports_volleyball_rounded, label: 'Volleyball', category: 'Fitness'),
  HabitIconItem(icon: Icons.skateboarding_rounded, label: 'Skating', category: 'Fitness'),

  // Health & Body
  HabitIconItem(icon: Icons.water_drop_outlined, label: 'Water', category: 'Health'),
  HabitIconItem(icon: Icons.local_drink_outlined, label: 'Hydrate', category: 'Health'),
  HabitIconItem(icon: Icons.bedtime_outlined, label: 'Sleep', category: 'Health'),
  HabitIconItem(icon: Icons.restaurant_outlined, label: 'Healthy meal', category: 'Health'),
  HabitIconItem(icon: Icons.favorite_border_rounded, label: 'Cardio health', category: 'Health'),
  HabitIconItem(icon: Icons.medication_outlined, label: 'Medicine', category: 'Health'),
  HabitIconItem(icon: Icons.spa_outlined, label: 'Wellness', category: 'Health'),
  HabitIconItem(icon: Icons.psychology_outlined, label: 'Mental health', category: 'Health'),
  HabitIconItem(icon: Icons.cleaning_services_outlined, label: 'Oral hygiene', category: 'Health'),
  HabitIconItem(icon: Icons.smoke_free_rounded, label: 'No smoking', category: 'Health'),
  HabitIconItem(icon: Icons.no_drinks_rounded, label: 'No alcohol', category: 'Health'),

  // Mind & Soul
  HabitIconItem(icon: Icons.self_improvement_rounded, label: 'Meditate', category: 'Mind'),
  HabitIconItem(icon: Icons.edit_note_rounded, label: 'Journal', category: 'Mind'),
  HabitIconItem(icon: Icons.volunteer_activism_outlined, label: 'Gratitude', category: 'Mind'),
  HabitIconItem(icon: Icons.wb_twilight_rounded, label: 'Reflection', category: 'Mind'),
  HabitIconItem(icon: Icons.eco_outlined, label: 'Nature', category: 'Mind'),
  HabitIconItem(icon: Icons.air_rounded, label: 'Deep breathing', category: 'Mind'),
  HabitIconItem(icon: Icons.phonelink_erase_rounded, label: 'Digital detox', category: 'Mind'),
  HabitIconItem(icon: Icons.nightlight_round_outlined, label: 'Night routine', category: 'Mind'),

  // Productivity & Growth
  HabitIconItem(icon: Icons.timer_outlined, label: 'Focus timer', category: 'Productivity'),
  HabitIconItem(icon: Icons.menu_book_rounded, label: 'Read books', category: 'Productivity'),
  HabitIconItem(icon: Icons.school_outlined, label: 'Study & learn', category: 'Productivity'),
  HabitIconItem(icon: Icons.code_rounded, label: 'Coding', category: 'Productivity'),
  HabitIconItem(icon: Icons.laptop_chromebook_rounded, label: 'Deep work', category: 'Productivity'),
  HabitIconItem(icon: Icons.checklist_rounded, label: 'Tasks', category: 'Productivity'),
  HabitIconItem(icon: Icons.savings_outlined, label: 'Save money', category: 'Productivity'),
  HabitIconItem(icon: Icons.attach_money_rounded, label: 'Budgeting', category: 'Productivity'),
  HabitIconItem(icon: Icons.track_changes_rounded, label: 'Goal setting', category: 'Productivity'),
  HabitIconItem(icon: Icons.draw_outlined, label: 'Writing', category: 'Productivity'),

  // Lifestyle & Creativity
  HabitIconItem(icon: Icons.wb_sunny_outlined, label: 'Morning routine', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.coffee_rounded, label: 'Coffee', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.emoji_food_beverage_outlined, label: 'Tea', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.pets_outlined, label: 'Pet care', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.local_florist_outlined, label: 'Plants', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.music_note_rounded, label: 'Music', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.brush_outlined, label: 'Art & sketching', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.camera_alt_outlined, label: 'Photography', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.auto_awesome_outlined, label: 'Tidy up', category: 'Lifestyle'),
  HabitIconItem(icon: Icons.translate_rounded, label: 'Language', category: 'Lifestyle'),
];

/// Data bundle for a tone color option.
class _ToneData {
  final int index;
  final String label;
  final Color bg;
  final Color iconColor;

  const _ToneData({
    required this.index,
    required this.label,
    required this.bg,
    required this.iconColor,
  });
}

List<_ToneData> _buildTones(HabitFlowTokens tokens) => [
      _ToneData(
        index: 0,
        label: 'Mint',
        bg: tokens.tileMint,
        iconColor: tokens.tileMintIcon,
      ),
      _ToneData(
        index: 1,
        label: 'Pink',
        bg: tokens.tilePink,
        iconColor: tokens.tilePinkIcon,
      ),
      _ToneData(
        index: 2,
        label: 'Butter',
        bg: tokens.tileButter,
        iconColor: tokens.tileButterIcon,
      ),
      _ToneData(
        index: 3,
        label: 'Lavender',
        bg: tokens.tileLavender,
        iconColor: tokens.tileLavenderIcon,
      ),
    ];

/// Redesigned IconCell:
/// - Uses [BentoCell] for seamless layout and theme compliance.
/// - The card background animates immediately when a color tone is selected.
/// - Minimalist accent selection ring on the active tone, soft pastel circles for others.
/// - Fixed "+" add-custom-icon button with dashed circular border.
/// - Scrollable default icons with smooth bidirectional fade mask on scroll.
/// - White pebble unselected icons, dark slate selected icon.
class IconCell extends StatefulWidget {
  final int selectedTone; // 0: mint, 1: pink, 2: butter, 3: lavender
  final IconData selectedIcon;
  final ValueChanged<int> onToneSelected;
  final ValueChanged<IconData> onIconSelected;

  const IconCell({
    super.key,
    required this.selectedTone,
    required this.selectedIcon,
    required this.onToneSelected,
    required this.onIconSelected,
  });

  /// Legacy alias so existing tests and callers compile.
  static List<HabitIconItem> get icons => kHabitIcons;

  @override
  State<IconCell> createState() => _IconCellState();
}

class _IconCellState extends State<IconCell> {
  final ScrollController _scrollController = ScrollController();
  double _leftFadeProgress = 0.0;
  double _rightFadeProgress = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollFade);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScrollFade();
    });
  }

  void _updateScrollFade() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final offset = position.pixels;
    final max = position.maxScrollExtent;
    const fadeDistance = 24.0;

    final newLeft = max > 0 ? (offset / fadeDistance).clamp(0.0, 1.0) : 0.0;
    final newRight = max > 0 ? ((max - offset) / fadeDistance).clamp(0.0, 1.0) : 0.0;

    if ((newLeft - _leftFadeProgress).abs() > 0.005 ||
        (newRight - _rightFadeProgress).abs() > 0.005) {
      setState(() {
        _leftFadeProgress = newLeft;
        _rightFadeProgress = newRight;
      });
    }
  }

  @override
  void didUpdateWidget(IconCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIcon != oldWidget.selectedIcon) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScrollFade();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollFade);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final tones = _buildTones(tokens);
    final clampedToneIndex = (widget.selectedTone >= 0 && widget.selectedTone < tones.length)
        ? widget.selectedTone
        : 0;
    final currentTone = tones[clampedToneIndex];

    // Ensure that if the selected icon is custom (not in default list), it is displayed first
    final isPreset = kHabitIcons.any((item) => item.icon.codePoint == widget.selectedIcon.codePoint);
    final displayIcons = [
      if (!isPreset)
        HabitIconItem(icon: widget.selectedIcon, label: 'Custom', category: 'Custom'),
      ...kHabitIcons,
    ];

    return BentoCell(
      label: 'Icon',
      backgroundColor: currentTone.bg,
      clipBehavior: Clip.antiAlias,
      trailingHeader: _ToneSelector(
        tones: tones,
        selectedIndex: clampedToneIndex,
        onSelect: widget.onToneSelected,
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  _updateScrollFade();
                  return false;
                },
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    if (bounds.width <= 0) {
                      return const LinearGradient(
                        colors: [Colors.black, Colors.black],
                      ).createShader(bounds);
                    }
                    const fadePx = 28.0;
                    final leftStop = (fadePx / bounds.width).clamp(0.01, 0.49);
                    final rightStop = (1.0 - (fadePx / bounds.width)).clamp(0.51, 0.99);

                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 1.0 - _leftFadeProgress),
                        Colors.black,
                        Colors.black,
                        Colors.black.withValues(alpha: 1.0 - _rightFadeProgress),
                      ],
                      stops: [
                        0.0,
                        leftStop,
                        rightStop,
                        1.0,
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: displayIcons.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = displayIcons[index];
                      final isSelected = item.icon.codePoint == widget.selectedIcon.codePoint;

                      return _IconChip(
                        item: item,
                        isSelected: isSelected,
                        tone: currentTone,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onIconSelected(item.icon);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _AddCustomChip(
              tone: currentTone,
              selectedIcon: widget.selectedIcon,
              onIconSelected: widget.onIconSelected,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper to identify whether a code point belongs to standard emoji ranges.
bool isEmojiCodePoint(int codePoint) {
  return (codePoint >= 0x1F000 && codePoint <= 0x1FAFF) ||
      (codePoint >= 0x2600 && codePoint <= 0x27BF) ||
      (codePoint >= 0x1F300 && codePoint <= 0x1F9FF);
}

/// Popular habit emojis matching the reference design.
const List<String> kHabitEmojis = [
  // Row 1
  '🥗', '🏃', '💧', '📚', '🧘',
  // Row 2
  '💪', '😴', '☀️', '🎧', '🧠',
  // Row 3
  '🍎', '🚴', '🏊', '🧹', '✍️',
  // Row 4
  '💊', '🦷', '🌱', '🧴', '🚬',
  // Row 5
  '📵', '🐕', '☕', '🎨', '🎸',
  // Row 6
  '💳', '🤲', '👑', '🌿', '🎯',
  // Row 7
  '🥑', '🚶', '🛌', '⏰', '🧊',
  // Row 8
  '🍇', '⚽', '🏀', '🎾', '🧗',
  // Row 9
  '🍵', '🕯️', '🧘‍♂️', '🚿', '🪴',
  // Row 10
  '💻', '🥪', '🥕', '🚴‍♂️', '📖',
  // Row 11
  '🌙', '🚶‍♂️', '🏆', '🥇', '🥋',
  '🏋️', '🍳', '🍉', '🍌', '🥛',
];

// ─────────────────────────────────────────────────────────────────────────────
// Individual Icon Chip
// ─────────────────────────────────────────────────────────────────────────────

class _IconChip extends StatefulWidget {
  final HabitIconItem item;
  final bool isSelected;
  final _ToneData tone;
  final VoidCallback onTap;

  const _IconChip({
    required this.item,
    required this.isSelected,
    required this.tone,
    required this.onTap,
  });

  @override
  State<_IconChip> createState() => _IconChipState();
}

class _IconChipState extends State<_IconChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = widget.isSelected
        ? (isDark ? tokens.text : const Color(0xFF16182B))
        : (isDark ? tokens.surface : Colors.white);
    final fgColor = widget.isSelected
        ? (isDark ? tokens.background : Colors.white)
        : (isDark ? tokens.text : const Color(0xFF16182B));

    final isEmoji = isEmojiCodePoint(widget.item.icon.codePoint) || widget.item.icon.fontFamily == null;

    return Semantics(
      label: widget.item.label,
      selected: widget.isSelected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Transform.scale(
          scale: _isPressed ? 0.92 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            alignment: Alignment.center,
            child: isEmoji
                ? Text(
                    String.fromCharCode(widget.item.icon.codePoint),
                    style: const TextStyle(fontSize: 22, height: 1),
                  )
                : Icon(
                    widget.item.icon,
                    size: 22,
                    color: fgColor,
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashed Circle Painter for Custom Add Button
// ─────────────────────────────────────────────────────────────────────────────

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;

  const _DashedCirclePainter({
    required this.color,
    this.strokeWidth = 1.4,
    this.dashLength = 4.5,
    this.dashSpace = 3.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * math.pi * radius;
    final step = dashLength + dashSpace;
    final count = (circumference / step).floor();
    if (count <= 0) return;

    final adjustedStep = circumference / count;
    final dashAngle = (dashLength / circumference) * 2 * math.pi;
    final stepAngle = (adjustedStep / circumference) * 2 * math.pi;

    for (int i = 0; i < count; i++) {
      final startAngle = i * stepAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.dashSpace != dashSpace;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Custom Icon Chip ("+")
// ─────────────────────────────────────────────────────────────────────────────

class _AddCustomChip extends StatelessWidget {
  final _ToneData tone;
  final IconData selectedIcon;
  final ValueChanged<IconData> onIconSelected;

  const _AddCustomChip({
    required this.tone,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? tokens.text.withValues(alpha: 0.45)
        : const Color(0xFF16182B).withValues(alpha: 0.45);
    final iconColor = isDark ? tokens.text : const Color(0xFF16182B);

    return Semantics(
      label: 'Add custom icon',
      button: true,
      child: Tooltip(
        message: 'More icons',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.lightImpact();
            _IconPickerSheet.show(
              context,
              tone: tone,
              selectedIcon: selectedIcon,
              onIconSelected: onIconSelected,
            );
          },
          child: CustomPaint(
            painter: _DashedCirclePainter(
              color: borderColor,
              strokeWidth: 1.4,
              dashLength: 4.5,
              dashSpace: 3.5,
            ),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                Icons.add_rounded,
                size: 22,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Redesigned Color Tone Selector
// ─────────────────────────────────────────────────────────────────────────────

class _ToneSelector extends StatelessWidget {
  final List<_ToneData> tones;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _ToneSelector({
    required this.tones,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: tones.map((tone) {
        final isSelected = tone.index == selectedIndex;
        return Semantics(
          label: '${tone.label} color',
          selected: isSelected,
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(tone.index);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: isSelected ? 26 : 22,
                height: isSelected ? 26 : 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.transparent : tone.bg,
                  border: isSelected
                      ? Border.all(
                          color: tokens.accent,
                          width: 2.2,
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Icon & Emoji Picker Bottom Sheet Matching Reference Design
// ─────────────────────────────────────────────────────────────────────────────

enum _PickerTab { icons, emoji }

class _IconPickerSheet extends StatefulWidget {
  final _ToneData tone;
  final IconData selectedIcon;
  final ValueChanged<IconData> onIconSelected;

  const _IconPickerSheet({
    required this.tone,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required _ToneData tone,
    required IconData selectedIcon,
    required ValueChanged<IconData> onIconSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _IconPickerSheet(
        tone: tone,
        selectedIcon: selectedIcon,
        onIconSelected: onIconSelected,
      ),
    );
  }

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  _PickerTab _selectedTab = _PickerTab.icons;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emojiInputController = TextEditingController();
  String? _previewEmojiText;

  @override
  void initState() {
    super.initState();
    // Pre-fill preview and default to Emoji tab if current habit icon is an emoji
    if (isEmojiCodePoint(widget.selectedIcon.codePoint) || widget.selectedIcon.fontFamily == null) {
      _previewEmojiText = String.fromCharCode(widget.selectedIcon.codePoint);
      _selectedTab = _PickerTab.emoji;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _emojiInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 350 ? 14.0 : 20.0;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        10,
        horizontalPadding,
        16 + keyboardHeight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.hairline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header: Back icon and title
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.field,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                    color: tokens.text,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Choose icon',
                style: AppUrbanist.sectionTitle(color: tokens.text).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Segmented Control: [ Icons | Emoji ]
          Container(
            height: 46,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: tokens.field,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _selectedTab = _PickerTab.icons),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _selectedTab == _PickerTab.icons
                            ? tokens.accent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Icons',
                        style: AppUrbanist.body(
                          color: _selectedTab == _PickerTab.icons
                              ? Colors.white
                              : tokens.mutedText,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _selectedTab = _PickerTab.emoji),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _selectedTab == _PickerTab.emoji
                            ? tokens.accent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Emoji',
                        style: AppUrbanist.body(
                          color: _selectedTab == _PickerTab.emoji
                              ? Colors.white
                              : tokens.mutedText,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Active Tab Body
          Expanded(
            child: _selectedTab == _PickerTab.icons
                ? _buildIconsTab(tokens, isDark)
                : _buildEmojiTab(tokens, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildIconsTab(HabitFlowTokens tokens, bool isDark) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = kAllHabitIcons.where((item) {
      return query.isEmpty ||
          item.label.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        // Search Bar
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: tokens.field,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20,
                color: tokens.mutedText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: AppUrbanist.body(color: tokens.text),
                  decoration: InputDecoration(
                    hintText: 'Search icons',
                    hintStyle: AppUrbanist.body(color: tokens.mutedText),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.cancel_rounded,
                    size: 18,
                    color: tokens.mutedText,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 5-column Grid
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'No matching icons found',
                    style: AppUrbanist.body(color: tokens.mutedText),
                  ),
                )
              : GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final isSelected = item.icon.codePoint == widget.selectedIcon.codePoint;

                    return Semantics(
                      label: item.label,
                      button: true,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onIconSelected(item.icon);
                          Navigator.of(context).pop();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? tokens.accent.withValues(alpha: 0.08)
                                : tokens.field,
                            borderRadius: BorderRadius.circular(18),
                            border: isSelected
                                ? Border.all(color: tokens.accent, width: 2.0)
                                : Border.all(color: Colors.transparent, width: 2.0),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: isDark ? tokens.text : const Color(0xFF16182B),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmojiTab(HabitFlowTokens tokens, bool isDark) {
    final hasPreview = _previewEmojiText != null && _previewEmojiText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Input Row: [ Preview Box ] [ TextField ] [ Use Button ]
        Row(
          children: [
            // Preview squircle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: tokens.field,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                hasPreview ? _previewEmojiText! : '?',
                style: TextStyle(
                  fontSize: hasPreview ? 24 : 18,
                  fontWeight: FontWeight.w600,
                  color: hasPreview ? null : tokens.mutedText,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // TextField
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: tokens.field,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                child: TextField(
                  controller: _emojiInputController,
                  onChanged: (text) {
                    final trimmed = text.trim();
                    setState(() {
                      if (trimmed.isNotEmpty) {
                        _previewEmojiText = String.fromCharCode(trimmed.runes.first);
                      } else {
                        _previewEmojiText = null;
                      }
                    });
                  },
                  style: AppUrbanist.body(color: tokens.text),
                  decoration: InputDecoration(
                    hintText: 'Type or paste an emoji',
                    hintStyle: AppUrbanist.body(color: tokens.mutedText),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // "Use" button
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: hasPreview
                  ? () {
                      HapticFeedback.selectionClick();
                      final rune = _previewEmojiText!.runes.first;
                      widget.onIconSelected(IconData(rune, fontFamily: null));
                      Navigator.of(context).pop();
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: hasPreview ? tokens.accent : tokens.field,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Use',
                  style: AppUrbanist.body(
                    color: hasPreview ? Colors.white : tokens.mutedText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Subheader: "Or pick one below."
        Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 10),
          child: Text(
            'Or pick one below.',
            style: AppUrbanist.body(
              color: tokens.mutedText,
              fontSize: 13,
            ),
          ),
        ),

        // 5-column Emoji Grid
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: kHabitEmojis.length,
            itemBuilder: (context, index) {
              final emoji = kHabitEmojis[index];
              final rune = emoji.runes.first;
              final isSelected = rune == widget.selectedIcon.codePoint;

              return Semantics(
                label: emoji,
                button: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onIconSelected(IconData(rune, fontFamily: null));
                    Navigator.of(context).pop();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? tokens.accent.withValues(alpha: 0.08)
                          : tokens.field,
                      borderRadius: BorderRadius.circular(18),
                      border: isSelected
                          ? Border.all(color: tokens.accent, width: 2.0)
                          : Border.all(color: Colors.transparent, width: 2.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24, height: 1),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
