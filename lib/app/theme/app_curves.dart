import 'package:flutter/animation.dart';

class AppCurves {
  AppCurves._();

  /// Default animation curve
  static const Curve standard = Curves.easeOutCubic;

  /// Used for page transitions and larger movements
  static const Curve emphasized = Curves.fastOutSlowIn;

  /// Used for playful interactions (buttons, checkboxes)
  static const Curve bounce = Curves.easeOutBack;
}