import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';

class HabitsLoadingState extends StatefulWidget {
  const HabitsLoadingState({super.key});

  @override
  State<HabitsLoadingState> createState() => _HabitsLoadingStateState();
}

class _HabitsLoadingStateState extends State<HabitsLoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, i) => SizedBox(height: AppSpacing.md),
      itemBuilder: (_, index) => AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          final shimmerGradient = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: const [
              Color(0xFFE8EFE6),
              Color(0xFFF5F9F4),
              Color(0xFFE8EFE6),
            ],
            stops: [
              (_shimmerController.value - 0.3).clamp(0.0, 1.0),
              _shimmerController.value.clamp(0.0, 1.0),
              (_shimmerController.value + 0.3).clamp(0.0, 1.0),
            ],
          );

          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.25),
              ),
              boxShadow: AppShadows.soft,
            ),
            clipBehavior: Clip.hardEdge,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left accent bar skeleton
                  Container(
                    width: 4.w,
                    decoration: BoxDecoration(
                      gradient: shimmerGradient,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          // Icon skeleton
                          Container(
                            width: 46.r,
                            height: 46.r,
                            decoration: BoxDecoration(
                              gradient: shimmerGradient,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),

                          SizedBox(width: 14.w),

                          // Text skeleton
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 14.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: shimmerGradient,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.pill,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Container(
                                  height: 11.h,
                                  width: 140.w,
                                  decoration: BoxDecoration(
                                    gradient: shimmerGradient,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.pill,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    Container(
                                      height: 20.h,
                                      width: 48.w,
                                      decoration: BoxDecoration(
                                        gradient: shimmerGradient,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.pill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: AppSpacing.xs),
                                    Container(
                                      height: 20.h,
                                      width: 44.w,
                                      decoration: BoxDecoration(
                                        gradient: shimmerGradient,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.pill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}