import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/services/notification_service.dart';
import '../common/frosted_scroll_header.dart';

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState
    extends State<NotificationHistoryScreen> {
  final _scrollController = ScrollController();

  List<PendingNotificationRequest> _pending = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final items =
        await NotificationService.instance.getPendingNotifications();
    if (mounted) {
      setState(() {
        _pending = items;
        _loading = false;
      });
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildDivider(bool isDark, HabitFlowTokens tokens) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: AppSpacing.dividerIndent,
      endIndent: AppSpacing.md,
      color: isDark
          ? tokens.border.withValues(alpha: 0.5)
          : const Color(0xFFF0EDF6),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusBarHeight = MediaQuery.of(context).padding.top;
    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final headerContentHeight = 58.h;
    final listTopPadding =
        statusBarHeight + headerContentHeight + AppSpacing.gap14;
    final listBottom = 74.h + 24.h + systemBottom + 32.h;

    final headerWidget = SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.gap12,
          AppSpacing.screenPadding,
          AppSpacing.gap10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? tokens.border.withValues(alpha: 0.5)
                      : tokens.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? tokens.border : tokens.hairline,
                    width: 1,
                  ),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(0xFF5B43B5)
                                .withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: tokens.text,
                  size: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Notifications',
                    style: AppUrbanist.sectionTitle(color: tokens.text),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Scheduled reminders',
                    style: AppUrbanist.body(
                      color: tokens.mutedText,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: tokens.background,
      body: Stack(
        children: [
          // ── Scrollable body ───────────────────────────────────────────────
          _loading
              ? const SizedBox.shrink()
              : ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    listTopPadding,
                    AppSpacing.screenPadding,
                    listBottom,
                  ),
                  children: _pending.isEmpty
                      ? [_EmptyState(topPadding: listTopPadding)]
                      : [
                          // Section label
                          Padding(
                            padding: EdgeInsets.only(
                              left: 4.w,
                              bottom: AppSpacing.sm,
                            ),
                            child: Text(
                              'SCHEDULED',
                              style: AppUrbanist.body(
                                color: tokens.accent,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ).copyWith(letterSpacing: 11.sp * 0.08),
                            ),
                          ),

                          // Card container
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? tokens.raised : tokens.surface,
                              borderRadius: BorderRadius.circular(24.r),
                              border: isDark
                                  ? Border.all(
                                      color: tokens.border,
                                      width: 1,
                                    )
                                  : null,
                              boxShadow: isDark ? null : tokens.cardShadow,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child: Column(
                                children: [
                                  for (int i = 0;
                                      i < _pending.length;
                                      i++) ...[
                                    _NotificationTile(
                                      item: _pending[i],
                                      tokens: tokens,
                                    ),
                                    if (i < _pending.length - 1)
                                      _buildDivider(isDark, tokens),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                ),

          // ── Frosted glass header overlay ──────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FrostedScrollHeader(
              controller: _scrollController,
              child: headerWidget,
            ),
          ),

          // ── Loading spinner ───────────────────────────────────────────────
          if (_loading)
            Center(
              child: CircularProgressIndicator(
                color: tokens.accent,
                strokeWidth: 2.5,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification Tile
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.tokens,
  });

  final PendingNotificationRequest item;
  final HabitFlowTokens tokens;

  /// Pick a badge color based on notification id so tiles get varied hues.
  Color _badgeBg(int id) {
    return switch (id % 4) {
      0 => tokens.tileLavender,
      1 => tokens.tileMint,
      2 => tokens.tileButter,
      _ => tokens.tilePink,
    };
  }

  Color _badgeIcon(int id) {
    return switch (id % 4) {
      0 => tokens.tileLavenderIcon,
      1 => tokens.tileMintIcon,
      2 => tokens.tileButterIcon,
      _ => tokens.tilePinkIcon,
    };
  }

  @override
  Widget build(BuildContext context) {
    final title = (item.title?.isNotEmpty ?? false)
        ? item.title!
        : 'Habit Reminder';
    final body = (item.body?.isNotEmpty ?? false) ? item.body! : '—';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.gap14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular accent icon badge
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: _badgeBg(item.id),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.notifications_active_rounded,
              color: _badgeIcon(item.id),
              size: 20.sp,
            ),
          ),

          SizedBox(width: AppSpacing.gap14),

          // Title + body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppUrbanist.body(
                    color: tokens.text,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppUrbanist.body(
                    color: tokens.mutedText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return SizedBox(
      height: MediaQuery.of(context).size.height - topPadding - 120.h,
      child: Center(
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
              alignment: Alignment.center,
              child: Icon(
                Icons.notifications_off_outlined,
                size: 32.sp,
                color: tokens.tileLavenderIcon,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No scheduled reminders',
              style: AppUrbanist.body(
                color: tokens.text,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Go to Settings → Notifications\nto set up a daily reminder.',
              textAlign: TextAlign.center,
              style: AppUrbanist.body(
                color: tokens.mutedText,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

