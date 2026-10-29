import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_flow_tokens.dart';

/// A frosted-glass header container that overlays a scrollable view.
///
/// At rest (scroll offset = [fadeStartOffset]), the background is completely
/// transparent and unblurred so the page title looks normal.
///
/// As the user scrolls past [fadeStartOffset] toward [fadeEndOffset], the
/// background smoothly transitions into a frosted glass effect (Gaussian blur
/// + translucent background tint + subtle bottom border), letting the colors
/// of cards scrolling behind it softly show through.
class FrostedScrollHeader extends StatefulWidget {
  final ScrollController controller;

  /// Header widget (typically title, subtitle, navigation buttons).
  final Widget child;

  /// Scroll offset in logical pixels where the frosted effect starts fading in.
  final double fadeStartOffset;

  /// Scroll offset in logical pixels where the frosted effect is fully opaque.
  final double fadeEndOffset;

  /// Maximum Gaussian blur sigma applied when fully scrolled.
  final double blurSigma;

  /// Maximum opacity of the background tint when fully scrolled.
  final double maxOpacity;

  const FrostedScrollHeader({
    super.key,
    required this.controller,
    required this.child,
    this.fadeStartOffset = 0,
    this.fadeEndOffset = 40,
    this.blurSigma = 16,
    this.maxOpacity = 0.85,
  });

  @override
  State<FrostedScrollHeader> createState() => _FrostedScrollHeaderState();
}

class _FrostedScrollHeaderState extends State<FrostedScrollHeader> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
    });
  }

  @override
  void didUpdateWidget(FrostedScrollHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onScroll();
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !widget.controller.hasClients) return;
    final offset = widget.controller.offset;
    final raw = (offset - widget.fadeStartOffset) /
        (widget.fadeEndOffset - widget.fadeStartOffset);
    final clamped = raw.clamp(0.0, 1.0);
    if ((clamped - _opacity).abs() > 0.005) {
      setState(() => _opacity = clamped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveMaxOpacity = isDark ? 0.80 : widget.maxOpacity;
    final effectiveBlur = widget.blurSigma * _opacity;

    Widget header = Container(
      decoration: BoxDecoration(
        color: tokens.background.withValues(
          alpha: effectiveMaxOpacity * _opacity,
        ),
      ),
      child: widget.child,
    );

    if (_opacity > 0) {
      header = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
            tileMode: TileMode.clamp,
          ),
          child: header,
        ),
      );
    }

    return header;
  }
}
