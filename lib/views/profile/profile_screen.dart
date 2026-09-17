import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app/config/service_locator.dart';
import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_event.dart';
import '../../controllers/auth/auth_state.dart';
import '../../repositories/auth/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _displayName;

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            final colorScheme = Theme.of(dialogContext).colorScheme;

            return AlertDialog(
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              title: Text(
                'Logout?',
                style: AppTextStyles.heading2.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              content: Text(
                'Are you sure you want to sign out of your HabitFlow account?',
                style: AppTextStyles.body.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.body.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  child: Text(
                    'Logout',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: Text(
            'Edit Name',
            style: AppTextStyles.heading2.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: TextFormField(
            initialValue: currentName,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: AppTextStyles.body.copyWith(color: colorScheme.onSurface),
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
              hintStyle: AppTextStyles.body.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.body.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                final name = editedName.trim();

                if (name.isEmpty) return;

                Navigator.of(dialogContext).pop(name);
              },
              child: const Text('Save'),
            ),
          ],
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
      context.read<AuthBloc>().add(UpdateUserNameRequested(newName));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = getIt<AuthRepository>();

    final email = authRepository.currentUserEmail ?? 'No email available';

    final userId = authRepository.currentUserId ?? 'Unknown';

    final repositoryName = authRepository.currentUserDisplayName?.trim();

    final userName =
        _displayName ??
        (repositoryName != null && repositoryName.isNotEmpty
            ? repositoryName
            : 'HabitFlow User');

    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          ),
          title: Text(
            'Profile',
            style: AppTextStyles.heading2.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.md),

                // Profile Avatar
                Container(
                  width: 96.r,
                  height: 96.r,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 46.sp,
                    color: colorScheme.primary,
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // User name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.heading2.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    InkWell(
                      onTap: () {
                        _showEditNameDialog(context, userName);
                      },
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 18.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                Text(
                  email,
                  style: AppTextStyles.body.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                _ProfileSection(
                  title: 'Account Information',
                  children: [
                    _ProfileInfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: email,
                    ),
                    _ProfileInfoTile(
                      icon: Icons.badge_outlined,
                      label: 'User ID',
                      value: userId,
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                _ProfileSection(
                  title: '',
                  children: [
                    _ActionTile(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      subtitle: 'Sign out of your account',
                      isDestructive: true,
                      onTap: () async {
                        final shouldLogout = await _showLogoutDialog(context);

                        if (shouldLogout && context.mounted) {
                          context.read<AuthBloc>().add(const LogoutRequested());
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
        ],

        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.25),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, size: 21.sp, color: colorScheme.primary),

          SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final color = isDestructive ? AppColors.error : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: color, size: 22.sp),
              ),

              SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
