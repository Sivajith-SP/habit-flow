import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/config/service_locator.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_flow_tokens.dart';
import '../../controllers/notifications/notifications_bloc.dart';
import '../../controllers/notifications/notifications_event.dart';
import '../../controllers/notifications/notifications_state.dart';
import 'widgets/notifications_main_view.dart';
import 'widgets/reminder_time_view.dart';

// =============================================================================
// NotificationsScreen – kept for GoRouter compat (renders the sheet as a page)
// =============================================================================

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationsModalRoute();
  }
}

class NotificationsModalRoute extends StatelessWidget {
  const NotificationsModalRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).maybePop(),
      child: Material(
        color: Colors.black.withValues(alpha: 0.45),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent taps inside sheet from dismissing it
            child: const NotificationsSheet(),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Helper – open the sheet imperatively from any call-site
// =============================================================================

void showNotificationsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) => BlocProvider(
      create: (_) =>
          getIt<NotificationsBloc>()..add(const LoadNotificationSettings()),
      child: const NotificationsSheet(),
    ),
  );
}

// =============================================================================
// NotificationsSheet – In-sheet subview navigation (matches Security pattern)
// =============================================================================

enum _NotificationsSheetView {
  main,
  reminderTime,
}

class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({super.key});

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  _NotificationsSheetView _currentView = _NotificationsSheetView.main;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final topPadding = mediaQuery.padding.top;
    final screenHeight = mediaQuery.size.height;
    final maxSheetHeight =
        screenHeight - topPadding - 16.h - bottomInset;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxSheetHeight > 200.h ? maxSheetHeight : 200.h,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? tokens.raised : tokens.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Stationary drag handle anchored at top of sheet ──────────
                Padding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
                  child: Center(
                    child: Container(
                      width: 36.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: tokens.mutedText.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                ),

                // ── Animated subview container ───────────────────────────────
                Flexible(
                  child: BlocBuilder<NotificationsBloc, NotificationsState>(
                    builder: (context, state) {
                      if (state is NotificationsLoading ||
                          state is NotificationsInitial) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: tokens.accent,
                            ),
                          ),
                        );
                      }

                      if (state is NotificationsFailure) {
                        return Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Center(
                            child: Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: AppUrbanist.body(
                                color: AppColors.error,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        );
                      }

                      if (state is NotificationsLoaded) {
                        final s = state.settings;

                        return AnimatedSize(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeInOutCubic,
                          alignment: Alignment.topCenter,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 320),
                            switchInCurve: Curves.easeInOutCubic,
                            switchOutCurve: Curves.easeInOutCubic,
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  ...previousChildren.map(
                                    (child) => Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: child,
                                    ),
                                  ),
                                  ?currentChild,
                                ],
                              );
                            },
                            transitionBuilder: (child, animation) {
                              final isSubView =
                                  child.key != const ValueKey('main');
                              final slideIn = Tween<Offset>(
                                begin: Offset(isSubView ? 1.0 : -0.25, 0.0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOutCubic,
                              ));
                              return SlideTransition(
                                position: slideIn,
                                child: FadeTransition(
                                  opacity: CurvedAnimation(
                                    parent: animation,
                                    curve: const Interval(0.15, 1.0,
                                        curve: Curves.easeIn),
                                  ),
                                  child: child,
                                ),
                              );
                            },
                            child: switch (_currentView) {
                              _NotificationsSheetView.reminderTime =>
                                ReminderTimeView(
                                  key: const ValueKey('reminder_time'),
                                  initialHour: s.reminderHour,
                                  initialMinute: s.reminderMinute,
                                  onBack: () => setState(() =>
                                      _currentView =
                                          _NotificationsSheetView.main),
                                  onSaved: () => setState(() =>
                                      _currentView =
                                          _NotificationsSheetView.main),
                                ),
                              _NotificationsSheetView.main =>
                                NotificationsMainView(
                                  key: const ValueKey('main'),
                                  tokens: tokens,
                                  isDark: isDark,
                                  notificationsEnabled: s.notificationsEnabled,
                                  habitRemindersEnabled:
                                      s.habitRemindersEnabled,
                                  reminderHour: s.reminderHour,
                                  reminderMinute: s.reminderMinute,
                                  onNotificationsToggle: (v) => context
                                      .read<NotificationsBloc>()
                                      .add(NotificationsEnabledChanged(v)),
                                  onHabitRemindersToggle: (v) => context
                                      .read<NotificationsBloc>()
                                      .add(HabitRemindersEnabledChanged(v)),
                                  onReminderTimeTap: () => setState(() =>
                                      _currentView =
                                          _NotificationsSheetView
                                              .reminderTime),
                                ),
                            },
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
