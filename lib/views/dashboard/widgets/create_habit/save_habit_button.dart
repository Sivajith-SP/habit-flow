import 'package:flutter/material.dart';

import '../../../../app/theme/app_flow_tokens.dart';

/// SaveHabitButton handles the CTA to submit the habit creation or edit.
///
/// Features:
/// - 56px tall, full-width, StadiumBorder
/// - Text: "Save habit" (17 / w800)
/// - Press feedback: scales to 0.98
/// - Disabled state: hairline-style background (text or white at 10%) with text at 38% opacity
/// - Enabled state: `ink` background with `onInk` text
/// - AnimatedContainer transitions over 250ms (respects reduced motion)
class SaveHabitButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onSave;

  const SaveHabitButton({
    super.key,
    required this.isEnabled,
    required this.onSave,
  });

  @override
  State<SaveHabitButton> createState() => _SaveHabitButtonState();
}

class _SaveHabitButtonState extends State<SaveHabitButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.flowTokens;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    final backgroundColor = widget.isEnabled
        ? tokens.ink
        : tokens.text.withValues(alpha: 0.10);

    final textColor = widget.isEnabled
        ? tokens.onInk
        : tokens.text.withValues(alpha: 0.38);

    return Semantics(
      button: true,
      enabled: widget.isEnabled,
      label: 'Save habit',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: widget.isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: widget.isEnabled ? widget.onSave : null,
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: disableAnimations
                ? Duration.zero
                : const Duration(milliseconds: 250),
            height: 56,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: const StadiumBorder(),
            ),
            child: Text(
              'Save habit',
              style: AppUrbanist.saveButton(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
