import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _meshController;

  @override
  void initState() {
    super.initState();
    _meshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _meshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _meshController,
        builder: (context, _) {
          final t = _meshController.value;
          final angle = t * 2 * math.pi;

          // Organic mesh movement offsets
          final o1x = size.width * (0.15 + 0.12 * math.sin(angle));
          final o1y = size.height * (0.12 + 0.08 * math.cos(angle * 0.8));

          final o2x = size.width * (0.85 + 0.10 * math.cos(angle * 1.1));
          final o2y = size.height * (0.25 + 0.14 * math.sin(angle * 0.9));

          final o3x = size.width * (0.45 + 0.18 * math.sin(angle * 0.7));
          final o3y = size.height * (0.60 + 0.10 * math.cos(angle * 1.2));

          // Gentle breathing scale for top-left glow
          final glowScale = 1.0 + 0.08 * math.sin(angle);

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Base Gradient Background Canvas (using AppColors theme tokens)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.meshBaseStart,
                      AppColors.background,
                      AppColors.meshBaseEnd,
                    ],
                  ),
                ),
              ),

              // 2. Vibrant Top-Left Sunlit Mesh Radial Glow (Matching image top-left highlight)
              Positioned(
                left: -size.width * 0.25,
                top: -size.height * 0.15,
                child: IgnorePointer(
                  child: SizedBox(
                    width: size.width * 1.4 * glowScale,
                    height: size.width * 1.4 * glowScale,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment.topLeft,
                          colors: [
                            AppColors.meshTopLeftGlow.withValues(alpha: 0.75),
                            AppColors.accentCream.withValues(alpha: 0.35),
                            AppColors.accentCream.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Animated Mesh Blob 1 — Top Left Mint Green Accent
              _MeshOrb(
                cx: o1x,
                cy: o1y,
                radius: size.width * 0.65,
                color: AppColors.meshMintAccent.withValues(alpha: 0.45),
              ),

              // 4. Animated Mesh Blob 2 — Top Right Soft Sunlit Amber
              _MeshOrb(
                cx: o2x,
                cy: o2y,
                radius: size.width * 0.75,
                color: AppColors.meshWarmGlow.withValues(alpha: 0.50),
              ),

              // 5. Animated Mesh Blob 3 — Mid/Bottom Sage Tint
              _MeshOrb(
                cx: o3x,
                cy: o3y,
                radius: size.width * 0.70,
                color: AppColors.primaryLight.withValues(alpha: 0.35),
              ),

              // Content
              SafeArea(
                child: widget.child,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MeshOrb extends StatelessWidget {
  final double cx;
  final double cy;
  final double radius;
  final Color color;

  const _MeshOrb({
    required this.cx,
    required this.cy,
    required this.radius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: cx - radius,
      top: cy - radius,
      child: IgnorePointer(
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}