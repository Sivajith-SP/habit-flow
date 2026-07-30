import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitflow/controllers/splash/splash_controller.dart';

import '../../app/theme/app_spacing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _gradientController;

  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOut,
      ),
    );

    _entranceController.forward();
    SplashController.checkAuth(context);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final primaryColor = colorScheme.primary;
    final secondaryGlowColor = colorScheme.secondary;
    final textPrimaryColor = colorScheme.onSurface;
    final textSecondaryColor = colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final t = _gradientController.value;

          // Subtle floating background gradient accents (ultra-low opacity)
          final g1x = size.width * (0.50 + 0.35 * math.sin(t * math.pi * 2));
          final g1y = size.height * (0.25 + 0.15 * math.cos(t * math.pi * 2 * 1.2));

          final g2x = size.width * (0.50 + 0.35 * math.cos(t * math.pi * 2 * 0.8));
          final g2y = size.height * (0.75 + 0.15 * math.sin(t * math.pi * 2 * 1.1));

          return Stack(
            fit: StackFit.expand,
            children: [
              // Clean theme background base
              ColoredBox(color: backgroundColor),

              // Soft top-right primary whisper glow
              Positioned(
                left: g1x - 200,
                top: g1y - 200,
                child: IgnorePointer(
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withValues(alpha: .12),
                          primaryColor.withValues(alpha: .04),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.50, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Soft bottom-left secondary whisper glow
              Positioned(
                left: g2x - 180,
                top: g2y - 180,
                child: IgnorePointer(
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          secondaryGlowColor.withValues(alpha: .10),
                          secondaryGlowColor.withValues(alpha: .03),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.50, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Center Minimal Brand Content
              Center(
                child: AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnim.value,
                      child: Opacity(
                        opacity: _fadeAnim.value,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Clean Minimal App Icon
                      Icon(
                        Icons.spa_rounded,
                        size: 64.sp,
                        color: primaryColor,
                      ),

                      SizedBox(height: AppSpacing.md),

                      // Clean Title Typography derived from Theme textTheme
                      Text(
                        "HabitFlow",
                        style: (textTheme.displayLarge ?? GoogleFonts.spaceGrotesk()).copyWith(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),

                      SizedBox(height: AppSpacing.xs),

                      // Minimal Tagline derived from Theme textTheme
                      Text(
                        "Build better habits daily",
                        style: (textTheme.bodyMedium ?? GoogleFonts.spaceGrotesk()).copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: textSecondaryColor.withValues(alpha: .75),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Minimal Progress Indicator
              Positioned(
                left: 0,
                right: 0,
                bottom: 48.h,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 22.w,
                        height: 22.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
