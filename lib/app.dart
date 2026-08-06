import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habitflow/app/router/app_router.dart';

import 'app/theme/app_theme.dart';

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'HabitFlow',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
          // Clamp text scale: respects accessibility up to 1.3x
          // without breaking fixed-height UI containers
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            final clampedScale = mediaQuery.textScaler.clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.3,
            );
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: clampedScale),
              child: child!,
            );
          },
        );
      },
    );
  }
}
