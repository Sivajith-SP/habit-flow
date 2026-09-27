import 'package:flutter/material.dart';

import '../../../../app/theme/app_flow_tokens.dart';

/// BentoCell represents an individual card within the bento grid.
///
/// Features:
/// - 26px border radius
/// - 14px vertical and 16px horizontal internal padding
/// - 1px border in Dark mode (none in Light mode)
/// - Configurable label with 13px / w700 style at 60% opacity
/// - Optional header trailing widget (e.g. color tone dots)
class BentoCell extends StatelessWidget {
  final String? label;
  final Widget? trailingHeader;
  final Color backgroundColor;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;

  const BentoCell({
    super.key,
    this.label,
    this.trailingHeader,
    required this.backgroundColor,
    required this.child,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(26),
        border: isDark ? Border.all(color: tokens.border, width: 1) : null,
      ),
      clipBehavior: clipBehavior,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null || trailingHeader != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (label != null)
                    Text(
                      label!,
                      style: AppUrbanist.tileLabel(
                        color: tokens.text.withValues(alpha: 0.60),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  ?trailingHeader,
                ],
              ),
            ),
          child,
        ],
      ),
    );
  }
}
