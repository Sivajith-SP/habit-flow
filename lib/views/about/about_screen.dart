import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_spacing.dart';
import '../common/frosted_scroll_header.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    final listBottom = 74.h + 24.h + systemBottom + 32.h;

    // Fixed header layout metrics:
    // gap12 (12.h) + button/content (36.r) + gap10 (10.h) => ~58.h
    // plus gap14 (14.h) => 72.h
    final headerContentHeight = 58.h;
    final listTopPadding = statusBarHeight + headerContentHeight + AppSpacing.gap14;

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
                    'About HabitFlow',
                    style: AppUrbanist.sectionTitle(color: tokens.text),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'App version & info',
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
              // ── 1. Hero card ──────────────────────────────────────────
              const _HeroCard(),

              SizedBox(height: AppSpacing.gap26),

              // ── 2. App Information ────────────────────────────────────
              _AboutSection(
                label: 'App Information',
                isDark: isDark,
                tokens: tokens,
                divider: _buildDivider(isDark, tokens),
                children: [
                  _AboutTile(
                    icon: Icons.info_outline_rounded,
                    iconBg: tokens.tileLavender,
                    iconColor: tokens.tileLavenderIcon,
                    title: 'Version',
                    subtitle: 'App version',
                    value: '1.0.0',
                  ),
                  _AboutTile(
                    icon: Icons.phone_android_rounded,
                    iconBg: tokens.tileLavender,
                    iconColor: tokens.tileLavenderIcon,
                    title: 'Platform',
                    subtitle: 'Device platform',
                    value: 'Android',
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.gap26),

              // ── 3. Technology ─────────────────────────────────────────
              _AboutSection(
                label: 'Technology',
                isDark: isDark,
                tokens: tokens,
                divider: _buildDivider(isDark, tokens),
                children: [
                  _AboutTile(
                    icon: Icons.flutter_dash_rounded,
                    iconBg: tokens.tileMint,
                    iconColor: tokens.tileMintIcon,
                    title: 'Built with',
                    subtitle: 'UI framework',
                    value: 'Flutter',
                  ),
                  _AboutTile(
                    icon: Icons.cloud_outlined,
                    iconBg: tokens.tileButter,
                    iconColor: tokens.tileButterIcon,
                    title: 'Backend',
                    subtitle: 'Cloud & auth',
                    value: 'Firebase',
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.gap36),

              // ── App Name & Version Footer ─────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'HabitFlow',
                      style: AppUrbanist.body(
                        color: tokens.text,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Version 1.0.0',
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

          // ── Frosted glass header overlay ─────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// Hero Card
// ─────────────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  static Widget _circle(double size, {required double alpha}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light: #6C53C9 → #8B6FE0 → #A78BE8  (≈ 135°)
    // Dark:  #3A2E6E → #5A46A8 → #7A64C9
    final gradientColors = isDark
        ? const [Color(0xFF3A2E6E), Color(0xFF5A46A8), Color(0xFF7A64C9)]
        : const [Color(0xFF6C53C9), Color(0xFF8B6FE0), Color(0xFFA78BE8)];

    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.7, 1.0),
            colors: gradientColors,
            stops: const [0.0, 0.55, 1.0],
          ),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF553CBE).withValues(alpha: 0.28),
              blurRadius: 30,
              offset: Offset(0, 14.h),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.hardEdge,
          children: [
            // Decorative circle 1 — large, top-right
            Positioned(
              top: -70.r,
              right: -50.r,
              child: _circle(180.r, alpha: 0.08),
            ),

            // Decorative circle 2 — small, bottom-left
            Positioned(
              bottom: -50.r,
              left: -30.r,
              child: _circle(120.r, alpha: 0.06),
            ),

            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App icon badge
                  Container(
                    width: 72.r,
                    height: 72.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.track_changes_rounded,
                      color: Colors.white,
                      size: 38.sp,
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // App name
                  Text(
                    'HabitFlow',
                    style: AppUrbanist.body(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ).copyWith(letterSpacing: -0.5),
                  ),

                  SizedBox(height: 6.h),

                  // Tagline
                  Text(
                    'Build better habits, one day at a time.',
                    textAlign: TextAlign.center,
                    style: AppUrbanist.body(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Version pill
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'v1.0.0',
                      style: AppUrbanist.body(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ).copyWith(letterSpacing: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// About Section
// ─────────────────────────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  final String label;
  final bool isDark;
  final HabitFlowTokens tokens;
  final Widget divider;
  final List<Widget> children;

  const _AboutSection({
    required this.label,
    required this.isDark,
    required this.tokens,
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

        // Card container — mirrors Settings list card
        Container(
          decoration: BoxDecoration(
            color: isDark ? tokens.raised : tokens.surface,
            borderRadius: BorderRadius.circular(24.r),
            border: isDark
                ? Border.all(color: tokens.border, width: 1)
                : null,
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

// ─────────────────────────────────────────────────────────────────────────────
// About Tile
// ─────────────────────────────────────────────────────────────────────────────

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String value;

  const _AboutTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
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
        children: [
          // Circular accent icon badge — matches SettingsTile exactly
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

          // Title + subtitle
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
                  subtitle,
                  maxLines: 1,
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

          SizedBox(width: AppSpacing.sm),

          // Static value
          Text(
            value,
            style: AppUrbanist.body(
              color: tokens.mutedText,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
