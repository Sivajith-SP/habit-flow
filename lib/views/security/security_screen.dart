import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_flow_tokens.dart';
import '../../app/theme/app_spacing.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_state.dart';
import 'change_password_screen.dart';
import 'delete_account_screen.dar.dart';

// =============================================================================
// Security Route Screen / Modal Route (Used by GoRouter for AppRoutes.security)
// =============================================================================

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SecurityModalRoute();
  }
}

class SecurityModalRoute extends StatelessWidget {
  const SecurityModalRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).maybePop(),
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent taps inside sheet from dismissing it
            child: const SecurityBottomSheet(),
          ),
        ),
      ),
    );
  }
}

/// Helper function to open the Security bottom sheet imperatively if needed.
void showSecuritySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) => BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: const SecurityBottomSheet(),
    ),
  );
}

// =============================================================================
// Security Bottom Sheet — adaptive height + in-sheet animated navigation
// =============================================================================

class SecurityBottomSheet extends StatefulWidget {
  const SecurityBottomSheet({super.key});

  @override
  State<SecurityBottomSheet> createState() => _SecurityBottomSheetState();
}

class _SecurityBottomSheetState extends State<SecurityBottomSheet> {
  bool _showDeleteView = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final topPadding = mediaQuery.padding.top;
    final screenHeight = mediaQuery.size.height;
    // Maximum height the sheet can occupy so it never overflows the screen above the keyboard
    final maxSheetHeight = screenHeight - topPadding - 16.h - bottomInset;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully.')),
          );
        }
        if (state is AuthInitial) {
          Navigator.of(context).maybePop();
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AnimatedPadding(
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
                  // Stationary drag handle anchored at top of sheet
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

                  // Smoothly animated size container wrapped in Flexible
                  Flexible(
                    child: AnimatedSize(
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
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (child, animation) {
                          final isDeleteView =
                              child.key == const ValueKey('delete');
                          final slideIn = Tween<Offset>(
                            begin: Offset(isDeleteView ? 1.0 : -0.25, 0.0),
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
                        child: _showDeleteView
                            ? SingleChildScrollView(
                                key: const ValueKey('delete'),
                                physics: const BouncingScrollPhysics(),
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                padding:
                                    EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 36.h),
                                child: DeleteAccountView(
                                  onBack: () => setState(
                                      () => _showDeleteView = false),
                                ),
                              )
                            : _buildMainView(tokens, isDark),
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

  Widget _buildMainView(HabitFlowTokens tokens, bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('main'),
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Subtitle
          Text(
            'Security',
            style: AppUrbanist.sectionTitle(color: tokens.text),
          ),
          SizedBox(height: 4.h),
          Text(
            'Manage your account security',
            style: AppUrbanist.body(color: tokens.mutedText),
          ),
          SizedBox(height: AppSpacing.xl),

          // ACCOUNT SECURITY caption
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: AppSpacing.sm),
            child: Text(
              'ACCOUNT SECURITY',
              style: AppUrbanist.daysCaption(color: tokens.accent),
            ),
          ),

          // Expandable Change Password card from change_password_screen.dart
          ExpandableChangePasswordCard(
            tokens: tokens,
            isDark: isDark,
          ),

          SizedBox(height: AppSpacing.xl),

          // DANGER ZONE caption
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: AppSpacing.sm),
            child: Text(
              'DANGER ZONE',
              style: AppUrbanist.daysCaption(color: AppColors.error),
            ),
          ),

          // Delete Account tile → slides in DeleteAccountView
          Container(
            decoration: BoxDecoration(
              color: isDark ? tokens.raised : tokens.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: isDark ? Border.all(color: tokens.border, width: 1) : null,
              boxShadow: isDark ? null : tokens.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: SecurityTile(
                icon: Icons.delete_outline_rounded,
                iconBg: isDark
                    ? tokens.tilePink
                    : AppColors.error.withValues(alpha: 0.12),
                iconColor: isDark ? tokens.tilePinkIcon : AppColors.error,
                title: 'Delete Account',
                subtitle: 'Opens a dedicated confirmation screen',
                titleColor: AppColors.error,
                onTap: () => setState(() => _showDeleteView = true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Reusable Security Tile
// =============================================================================

class SecurityTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  const SecurityTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppUrbanist.body(
                        color: titleColor ?? tokens.text,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
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
              Icon(
                Icons.chevron_right_rounded,
                color: tokens.mutedText.withValues(alpha: 0.60),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}