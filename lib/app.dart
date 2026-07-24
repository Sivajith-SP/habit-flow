import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home:const Scaffold(
        body: Center(
          child: Text('HabitFlow'),
        ),
      ),
    );
  }
}