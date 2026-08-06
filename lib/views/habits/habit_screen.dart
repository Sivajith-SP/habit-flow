import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF3F6F2),
            Color(0xFFFAFCFA),
            Colors.white,
          ],
          stops: [0.0, 0.35, 1.0],
        ),
      ),
      child: Center(
        child: Text(
          "Habits",
          style: AppTextStyles.heading2,
        ),
      ),
    );
  }
}
