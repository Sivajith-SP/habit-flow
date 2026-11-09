import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_flow_tokens.dart';

/// Interactive festive confetti burst that fires across the screen.
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});

  @override
  State<ConfettiOverlay> createState() => ConfettiOverlayState();
}

class ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(() {
        if (mounted) setState(() {});
      })
     ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _particles.clear();
            });
          }
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Triggers a celebratory confetti explosion.
  void blast(HabitFlowTokens tokens) {
    if (!mounted) return;
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) return;

    final colors = [
      tokens.tilePinkIcon,
      tokens.tileMintIcon,
      tokens.tileLavenderIcon,
      tokens.tileButterIcon,
      tokens.accent,
      tokens.tilePink,
      tokens.tileMint,
    ];

    _particles.clear();
    const particleCount = 65;

    for (int i = 0; i < particleCount; i++) {
      // Spawn around horizontal center, bottom-third of the screen
      final angle = -math.pi / 2 + (_random.nextDouble() - 0.5) * (math.pi * 0.85);
      final speed = 650.0 + _random.nextDouble() * 550.0;
      final size = 7.0 + _random.nextDouble() * 8.0;
      final color = colors[_random.nextInt(colors.length)];
      final isCircle = _random.nextBool();
      final rotationSpeed = (_random.nextDouble() - 0.5) * 16.0;

      _particles.add(
        _ConfettiParticle(
          vx: math.cos(angle) * speed,
          vy: math.sin(angle) * speed,
          size: size,
          color: color,
          isCircle: isCircle,
          rotationSpeed: rotationSpeed,
          rotation: _random.nextDouble() * math.pi * 2,
        ),
      );
    }

    setState(() {
      _isPlaying = true;
    });

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPlaying || _particles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  double x = 0;
  double y = 0;
  final double vx;
  final double vy;
  final double size;
  final Color color;
  final bool isCircle;
  final double rotationSpeed;
  final double rotation;

  _ConfettiParticle({
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.isCircle,
    required this.rotationSpeed,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final startX = size.width * 0.5;
    final startY = size.height * 0.65;
    final t = progress * 2.2; // simulated time in seconds
    const gravity = 880.0;

    // Fade out smoothly towards the end
    final alpha = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in particles) {
      final currentX = startX + p.vx * t * 0.75;
      final currentY = startY + p.vy * t + 0.5 * gravity * t * t;
      final currentRotation = p.rotation + p.rotationSpeed * t;

      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha * p.color.a)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRotation);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size * 0.5, paint);
      } else {
        // Fluttering ribbon effect (simulated 3D rotation flip via cos)
        final flip = math.cos(t * 8 + p.rotation);
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: p.size * 0.7,
          height: p.size * 1.5 * flip.abs(),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

