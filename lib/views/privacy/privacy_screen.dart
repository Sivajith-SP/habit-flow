import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_spacing.dart';
import '../common/frosted_scroll_header.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

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

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusBarHeight = MediaQuery.of(context).padding.top;
    final systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final listBottom = 74.h + 24.h + systemBottom + 32.h;

    // Header layout metrics (aligned with AboutScreen and ProfileScreen)
    final headerContentHeight = 58.h;
    final listTopPadding =
        statusBarHeight + headerContentHeight + AppSpacing.gap14;

    Widget headerWidget = SafeArea(
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
                    'Privacy',
                    style: AppUrbanist.sectionTitle(color: tokens.text),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Data & security',
                    style: AppUrbanist.body(
                      color: tokens.mutedText,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
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
          // ── Scrollable Body ───────────────────────────────────────────────
          ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              listTopPadding,
              AppSpacing.screenPadding,
              listBottom,
            ),
            children: [
              // 1. Privacy Hero Card
              _PrivacyHeroCard(tokens: tokens, isDark: isDark),

              SizedBox(height: AppSpacing.gap26),

              // 2. Data & Storage Card
              _PrivacyCardGroup(
                label: 'DATA & STORAGE',
                tokens: tokens,
                isDark: isDark,
                divider: _buildDivider(isDark, tokens),
                children: [
                  _PrivacyTile(
                    icon: Icons.person_outline_rounded,
                    iconBg: tokens.tileLavender,
                    iconColor: tokens.tileLavenderIcon,
                    title: 'Account Information',
                    description:
                        'HabitFlow uses Firebase Authentication to securely manage your account and sign-in information.',
                  ),
                  _PrivacyTile(
                    icon: Icons.storage_outlined,
                    iconBg: tokens.tileMint,
                    iconColor: tokens.tileMintIcon,
                    title: 'Habit Data',
                    description:
                        'Your habit information is stored locally on your device using Hive so the app can work with your habits efficiently.',
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.gap26),

              // 3. Security & Alerts Card
              _PrivacyCardGroup(
                label: 'SECURITY & ALERTS',
                tokens: tokens,
                isDark: isDark,
                divider: _buildDivider(isDark, tokens),
                children: [
                  _PrivacyTile(
                    icon: Icons.notifications_none_rounded,
                    iconBg: tokens.tileButter,
                    iconColor: tokens.tileButterIcon,
                    title: 'Notifications',
                    description:
                        'If you enable habit reminders, HabitFlow schedules notifications on your device at the time you choose.',
                  ),
                  _PrivacyTile(
                    icon: Icons.security_outlined,
                    iconBg: tokens.tilePink,
                    iconColor: tokens.tilePinkIcon,
                    title: 'Data Security',
                    description:
                        'HabitFlow uses the security mechanisms provided by the services it relies on. Keep your account credentials private and use a secure password.',
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.gap26),

              // 4. Disclaimer Note
              _PrivacyDisclaimerCard(tokens: tokens, isDark: isDark),
            ],
          ),

          // ── Frosted Scroll Header Overlay ─────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FrostedScrollHeader(
              controller: _scrollController,
              child: headerWidget,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Privacy Hero Card
// =============================================================================

class _PrivacyHeroCard extends StatelessWidget {
  final HabitFlowTokens tokens;
  final bool isDark;

  const _PrivacyHeroCard({
    required this.tokens,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [tokens.raised, const Color(0xFF28243A)]
              : [tokens.surface, const Color(0xFFF3EDFD)],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
        boxShadow: isDark ? null : tokens.cardShadow,
      ),
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: tokens.tileLavender,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.privacy_tip_outlined,
              color: tokens.tileLavenderIcon,
              size: 24.sp,
            ),
          ),
          SizedBox(height: AppSpacing.gap14),
          Text(
            'Your privacy matters',
            style: AppUrbanist.sectionTitle(color: tokens.text),
          ),
          SizedBox(height: 4.h),
          Text(
            'Here is a simple overview of how HabitFlow handles the information used by the app.',
            style: AppUrbanist.body(
              color: tokens.mutedText,
              fontSize: 13.sp,
            ).copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Privacy Card Group
// =============================================================================

class _PrivacyCardGroup extends StatelessWidget {
  final String label;
  final HabitFlowTokens tokens;
  final bool isDark;
  final Widget divider;
  final List<Widget> children;

  const _PrivacyCardGroup({
    required this.label,
    required this.tokens,
    required this.isDark,
    required this.divider,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: AppSpacing.sm),
          child: Text(
            label.toUpperCase(),
            style: AppUrbanist.body(
              color: tokens.accent,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ).copyWith(letterSpacing: 11.sp * 0.08),
          ),
        ),

        // Rounded Card container
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
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1) divider,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Privacy Tile
// =============================================================================

class _PrivacyTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String description;

  const _PrivacyTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.gap14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular icon badge matching Settings
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),

          SizedBox(width: AppSpacing.gap14),

          // Title & Description
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
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: AppUrbanist.body(
                    color: tokens.mutedText,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                  ).copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Privacy Disclaimer Card
// =============================================================================

class _PrivacyDisclaimerCard extends StatelessWidget {
  final HabitFlowTokens tokens;
  final bool isDark;

  const _PrivacyDisclaimerCard({
    required this.tokens,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? tokens.raised : tokens.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
        boxShadow: isDark ? null : tokens.cardShadow,
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: tokens.tileLavender.withValues(alpha: isDark ? 0.4 : 0.6),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.info_outline_rounded,
              color: tokens.tileLavenderIcon,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'This information describes how the current version of HabitFlow handles your data. It may be updated as the app evolves.',
              style: AppUrbanist.body(
                color: tokens.mutedText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ).copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
