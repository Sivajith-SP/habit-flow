import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_flow_tokens.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../controllers/theme/theme_cubit.dart';
import 'settings_tile.dart';

/// An expandable settings tile that displays the active theme mode and smoothly expands
/// on tap to present a 3-option theme selector (System, Light, Dark).
class AppearanceTile extends StatefulWidget {
  const AppearanceTile({super.key});

  @override
  State<AppearanceTile> createState() => _AppearanceTileState();
}

class _AppearanceTileState extends State<AppearanceTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // Dynamic leading icon based on selected theme mode
        final tileIcon = switch (themeMode) {
          ThemeMode.system => Icons.desktop_windows_outlined,
          ThemeMode.light => Icons.wb_sunny_outlined,
          ThemeMode.dark => Icons.nightlight_outlined,
        };

        // Dynamic subtitle
        final subtitle = switch (themeMode) {
          ThemeMode.system => 'System default',
          ThemeMode.light => 'Light',
          ThemeMode.dark => 'Dark',
        };

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingsTile(
              icon: tileIcon,
              iconBg: tokens.tileMint,
              iconColor: tokens.tileMintIcon,
              title: 'Appearance',
              subtitle: subtitle,
              trailing: AnimatedRotation(
                turns: _isExpanded ? 0.25 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: tokens.mutedText.withValues(alpha: 0.60),
                  size: 20.sp,
                ),
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),

            // Smooth expansion area for theme options
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _isExpanded
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          0,
                          AppSpacing.md,
                          AppSpacing.gap14,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.buttonPadding,
                            vertical: AppSpacing.gap12,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? tokens.background
                                : const Color(0xFFF3F0FA),
                            borderRadius: BorderRadius.circular(16.r),
                            border: isDark
                                ? Border.all(
                                    color: tokens.border.withValues(alpha: 0.6),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _ThemeOptionItem(
                                  icon: Icons.desktop_windows_outlined,
                                  label: 'System',
                                  tooltip: 'System theme',
                                  isSelected: themeMode == ThemeMode.system,
                                  tokens: tokens,
                                  onTap: () => context
                                      .read<ThemeCubit>()
                                      .setThemeMode(ThemeMode.system),
                                ),
                              ),
                              Expanded(
                                child: _ThemeOptionItem(
                                  icon: Icons.wb_sunny_outlined,
                                  label: 'Light',
                                  tooltip: 'Light theme',
                                  isSelected: themeMode == ThemeMode.light,
                                  tokens: tokens,
                                  onTap: () => context
                                      .read<ThemeCubit>()
                                      .setThemeMode(ThemeMode.light),
                                ),
                              ),
                              Expanded(
                                child: _ThemeOptionItem(
                                  icon: Icons.nightlight_outlined,
                                  label: 'Dark',
                                  tooltip: 'Dark theme',
                                  isSelected: themeMode == ThemeMode.dark,
                                  tokens: tokens,
                                  onTap: () => context
                                      .read<ThemeCubit>()
                                      .setThemeMode(ThemeMode.dark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeOptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final bool isSelected;
  final HabitFlowTokens tokens;
  final VoidCallback onTap;

  const _ThemeOptionItem({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.isSelected,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: isSelected ? tokens.accent : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: tokens.accent.withValues(alpha: 0.30),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: isSelected ? Colors.white : tokens.mutedText,
                ),
              ),
              SizedBox(height: AppSpacing.buttonPadding),
              Text(
                label,
                style: AppUrbanist.body(
                  color: isSelected ? tokens.accent : tokens.mutedText,
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
