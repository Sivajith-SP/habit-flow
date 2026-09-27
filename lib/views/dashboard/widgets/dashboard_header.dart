import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_flow_tokens.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({
    super.key,
    this.userName = 'Sivajith',
    this.completedHabits = 0,
    this.totalHabits = 0,
    this.onSearchTap,
    this.onNotificationsTap,
  });

  final String userName;
  final int completedHabits;
  final int totalHabits;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  String _dateSubtitle() {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initial = widget.userName.trim().isNotEmpty ? widget.userName.trim()[0].toUpperCase() : 'S';

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Pill with avatar circle + name
            Container(
              padding: EdgeInsets.only(
                left: 4.w,
                right: 16.w,
                top: 4.h,
                bottom: 4.h,
              ),
              decoration: BoxDecoration(
                color: tokens.raised,
                borderRadius: BorderRadius.circular(999),
                boxShadow: isDark ? null : tokens.cardShadow,
                border: isDark ? Border.all(color: tokens.border, width: 1) : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: tokens.tileLavender,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: AppUrbanist.sectionTitle(color: tokens.tileLavenderIcon),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    widget.userName,
                    style: AppUrbanist.habitName(color: tokens.text),
                  ),
                ],
              ),
            ),

            // Right: 44px round search and notification buttons
            Row(
              children: [
                // Search button
                Semantics(
                  button: true,
                  label: 'Search habits',
                  child: InkWell(
                    onTap: widget.onSearchTap ?? () {},
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: tokens.raised,
                        shape: BoxShape.circle,
                        boxShadow: isDark ? null : tokens.cardShadow,
                        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.search_rounded,
                          size: 22.sp,
                          color: tokens.text,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                // Notification button with pink dot
                Semantics(
                  button: true,
                  label: 'Notifications',
                  child: InkWell(
                    onTap: widget.onNotificationsTap ??
                        () {
                          context.push(AppRoutes.notifications);
                        },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: tokens.raised,
                        shape: BoxShape.circle,
                        boxShadow: isDark ? null : tokens.cardShadow,
                        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 22.sp,
                            color: tokens.text,
                          ),
                          // Small pink unread dot
                          // Positioned(
                          //   top: 10.r,
                          //   right: 11.r,
                          //   child: Container(
                          //     width: 7.r,
                          //     height: 7.r,
                          //     decoration: BoxDecoration(
                          //       color: tokens.tilePinkIcon,
                          //       shape: BoxShape.circle,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // Greeting — single line, auto-scales to fit any name length
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '${_greeting()} ${widget.userName}',
            style: AppUrbanist.greeting(color: tokens.text)
                .copyWith(fontSize: 30.sp),
          ),
        ),

        SizedBox(height: 4.h),

        // Subtitle — real current date: "Sunday, Sep 20"
        Text(
          _dateSubtitle(),
          style: AppUrbanist.body(color: tokens.mutedText),
        ),
      ],
    );

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: column,
      ),
    );
  }
}