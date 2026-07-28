import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habitflow/controllers/splash/splash_controller.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SplashController.checkAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.spa_rounded, size: 90.r, color: AppColors.primary),
                  SizedBox(height: AppSpacing.lg),
                  Text("HabitFlow", style: AppTextStyles.heading1),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    "Build Better Habits Every Day",
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Bottom loader
            Positioned(
              left: 0,
              right: 0,
              bottom: 40.h,
              child: Column(
                children: [
                  SizedBox(
                    width: 28.w,
                    height: 28.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.primary,
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
