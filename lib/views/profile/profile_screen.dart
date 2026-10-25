import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/config/service_locator.dart';
import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_event.dart';
import '../../controllers/auth/auth_state.dart';
import '../../controllers/statistics/statistics_bloc.dart';
import '../../controllers/statistics/statistics_state.dart';
import '../../repositories/auth/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _displayName;

  // ─────────────────────────────────────────────
  // Dialogs — logic unchanged
  // ─────────────────────────────────────────────

  Future<bool> _showLogoutDialog(BuildContext context) async {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              backgroundColor: isDark ? tokens.raised : tokens.surface,
              surfaceTintColor: Colors.transparent,
              elevation: isDark ? 0 : 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
                side: isDark
                    ? BorderSide(color: tokens.border, width: 1)
                    : BorderSide.none,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top circular icon badge
                    Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: BoxDecoration(
                        color: isDark
                            ? tokens.tilePink
                            : AppColors.error.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.logout_rounded,
                        color: isDark ? tokens.tilePinkIcon : AppColors.error,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    // Title
                    Text(
                      'Log out?',
                      textAlign: TextAlign.center,
                      style: AppUrbanist.sectionTitle(color: tokens.text),
                    ),
                    SizedBox(height: 6.h),
                    // Content
                    Text(
                      'Are you sure you want to sign out of your HabitFlow account?',
                      textAlign: TextAlign.center,
                      style: AppUrbanist.body(
                        color: tokens.mutedText,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isDark
                                  ? tokens.surface
                                  : tokens.background,
                              side: BorderSide(color: tokens.hairline),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(
                              'Cancel',
                              style: AppUrbanist.body(
                                color: tokens.text,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            onPressed: () =>
                                Navigator.pop(dialogContext, true),
                            child: Text(
                              'Log out',
                              style: AppUrbanist.body(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
        ) ??
        false;
  }

  Future<void> _showEditNameDialog(
    BuildContext context,
    String currentName,
  ) async {
    String editedName = currentName;
    final authBloc = context.read<AuthBloc>(); // cache before async gap
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: isDark ? tokens.raised : tokens.surface,
          surfaceTintColor: Colors.transparent,
          elevation: isDark ? 0 : 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: isDark
                ? BorderSide(color: tokens.border, width: 1)
                : BorderSide.none,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: tokens.tileLavender,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.edit_rounded,
                        color: tokens.tileLavenderIcon,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Edit Name',
                        style: AppUrbanist.sectionTitle(color: tokens.text),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                TextFormField(
                  initialValue: currentName,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  style: AppUrbanist.body(
                    color: tokens.text,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    editedName = value;
                  },
                  onFieldSubmitted: (value) {
                    final name = value.trim();
                    if (name.isNotEmpty) {
                      Navigator.of(dialogContext).pop(name);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: AppUrbanist.body(
                      color: tokens.mutedText.withValues(alpha: 0.60),
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: tokens.field,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: tokens.hairline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: tokens.hairline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide:
                          BorderSide(color: tokens.accent, width: 1.5),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              isDark ? tokens.surface : tokens.background,
                          side: BorderSide(color: tokens.hairline),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.pill),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'Cancel',
                          style: AppUrbanist.body(
                            color: tokens.text,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: tokens.accent,
                          foregroundColor: tokens.onAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.pill),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () {
                          final name = editedName.trim();
                          if (name.isEmpty) return;
                          Navigator.of(dialogContext).pop(name);
                        },
                        child: Text(
                          'Save',
                          style: AppUrbanist.body(
                            color: tokens.onAccent,
                            fontWeight: FontWeight.w700,
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

    if (result != null && result.trim().isNotEmpty && mounted) {
      final newName = result.trim();

      // Immediate UI update
      setState(() {
        _displayName = newName;
      });

      // Update Firebase through Bloc
      authBloc.add(UpdateUserNameRequested(newName));
    }
  }

  // ─────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final authRepository = getIt<AuthRepository>();
    final tokens = context.flowTokens;

    final email = authRepository.currentUserEmail ?? 'No email available';
    final userId = authRepository.currentUserId ?? 'Unknown';

    final repositoryName = authRepository.currentUserDisplayName?.trim();
    final userName =
        _displayName ??
        (repositoryName != null && repositoryName.isNotEmpty
            ? repositoryName
            : 'HabitFlow User');

    // Member since date — derived from Firebase metadata
    DateTime? creationTime;
    try {
      creationTime = FirebaseAuth.instance.currentUser?.metadata.creationTime;
    } catch (_) {
      creationTime = null;
    }
    final memberSince =
        creationTime != null ? _formatMemberSince(creationTime) : null;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: tokens.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, color: tokens.text),
          ),
          title: Text(
            'Profile',
            style: AppUrbanist.sectionTitle(color: tokens.text),
          ),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.md),

                // ── Profile Header ───────────────────────────────
                _ProfileHeader(
                  userName: userName,
                  email: email,
                  memberSince: memberSince,
                  onEditName: () => _showEditNameDialog(context, userName),
                  tokens: tokens,
                ),

                SizedBox(height: AppSpacing.xl),

                // ── Stats Row ────────────────────────────────────
                _StatsRow(tokens: tokens),

                SizedBox(height: AppSpacing.lg),

                // ── Section label ────────────────────────────────
                Padding(
                  padding: EdgeInsets.only(left: 2.w, bottom: AppSpacing.sm),
                  child: Text(
                    'ACCOUNT',
                    style: AppUrbanist.daysCaption(color: tokens.mutedText),
                  ),
                ),

                // ── Account Info Card ────────────────────────────
                _AccountInfoCard(
                  email: email,
                  userId: userId,
                  tokens: tokens,
                ),

                SizedBox(height: AppSpacing.md),

                // ── Logout Card ──────────────────────────────────
                _LogoutCard(
                  tokens: tokens,
                  onTap: () async {
                    final shouldLogout = await _showLogoutDialog(context);
                    if (shouldLogout && context.mounted) {
                      context.read<AuthBloc>().add(const LogoutRequested());
                    }
                  },
                ),

                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatMemberSince(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Header — flat, centered, no gradient card
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final String userName;
  final String email;
  final String? memberSince;
  final VoidCallback onEditName;
  final HabitFlowTokens tokens;

  const _ProfileHeader({
    required this.userName,
    required this.email,
    required this.memberSince,
    required this.onEditName,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final initial = userName.trim().isNotEmpty
        ? userName.trim()[0].toUpperCase()
        : '?';

    return Center(
      child: Column(
        children: [
          // ── Avatar circle with initial letter ──────────────
          Container(
            width: 96.r,
            height: 96.r,
            decoration: BoxDecoration(
              color: tokens.tileLavender,
              shape: BoxShape.circle,
              boxShadow: tokens.cardShadow,
            ),
            child: Center(
              child: Text(
                initial,
                style: AppUrbanist.body(
                  color: tokens.tileLavenderIcon,
                  fontSize: 38.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          SizedBox(height: 14.h),

          // ── Name + edit icon ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppUrbanist.body(
                    color: tokens.text,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onEditName,
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18.sp,
                    color: tokens.accent,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          // ── Email ──────────────────────────────────────────
          Text(
            email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppUrbanist.body(
              color: tokens.mutedText,
              fontSize: 13.sp,
            ),
          ),

          // ── Member since chip (mint green) ─────────────────
          if (memberSince != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: tokens.tileMint,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 13.sp,
                    color: tokens.tileMintIcon,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Member since $memberSince',
                    style: AppUrbanist.body(
                      color: tokens.tileMintIcon,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final HabitFlowTokens tokens;

  const _StatsRow({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      builder: (context, state) {
        final String habits;
        final String completion;
        final String streak;

        if (state is StatisticsLoaded) {
          habits = '${state.totalHabits}';
          final pct = state.monthlyTotal > 0
              ? ((state.monthlyCompleted / state.monthlyTotal) * 100)
                    .round()
                    .toString()
              : '0';
          completion = '$pct%';
          streak = '${state.currentStreak}';
        } else {
          habits = '--';
          completion = '--%';
          streak = '--';
        }

        return Row(
          children: [
            Expanded(
              child: _StatCard(
                value: habits,
                label: 'Habits',
                tokens: tokens,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatCard(
                value: completion,
                label: 'Completion',
                tokens: tokens,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatCard(
                value: streak,
                label: 'Day Streak',
                tokens: tokens,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final HabitFlowTokens tokens;

  const _StatCard({
    required this.value,
    required this.label,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: tokens.cardShadow,
        border: tokens.cardBorder,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppUrbanist.body(
              color: tokens.text,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppUrbanist.daysCaption(color: tokens.mutedText),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Account Info Card
// ─────────────────────────────────────────────────────────────────────────────

class _AccountInfoCard extends StatelessWidget {
  final String email;
  final String userId;
  final HabitFlowTokens tokens;

  const _AccountInfoCard({
    required this.email,
    required this.userId,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: tokens.cardShadow,
        border: tokens.cardBorder,
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email,
            tokens: tokens,
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 60.w,
            endIndent: AppSpacing.md,
            color: tokens.hairline,
          ),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'User ID',
            value: userId,
            tokens: tokens,
            trailing: _CopyButton(text: userId, tokens: tokens),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final HabitFlowTokens tokens;
  final Widget? trailing;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.tokens,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14.h,
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: tokens.tileLavender,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: tokens.tileLavenderIcon),
          ),

          SizedBox(width: AppSpacing.md),

          // Label + value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppUrbanist.daysCaption(color: tokens.mutedText),
                ),
                SizedBox(height: 3.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppUrbanist.body(
                    color: tokens.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          if (trailing != null) ...[
            SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String text;
  final HabitFlowTokens tokens;

  const _CopyButton({required this.text, required this.tokens});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copy,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Icon(
          _copied ? Icons.check_rounded : Icons.copy_rounded,
          key: ValueKey(_copied),
          size: 18.sp,
          color: _copied ? AppColors.success : widget.tokens.mutedText,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logout Card
// ─────────────────────────────────────────────────────────────────────────────

class _LogoutCard extends StatelessWidget {
  final HabitFlowTokens tokens;
  final VoidCallback onTap;

  const _LogoutCard({required this.tokens, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: tokens.cardShadow,
        border: tokens.cardBorder,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14.h,
            ),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 18.sp,
                    color: AppColors.error,
                  ),
                ),

                SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log out',
                        style: AppUrbanist.body(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Sign out of your account',
                        style: AppUrbanist.daysCaption(
                          color: tokens.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: tokens.mutedText,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
