import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'controllers/theme/theme_cubit.dart';

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit()..loadTheme(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'HabitFlow',
                debugShowCheckedModeBanner: false,

                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,

                routerConfig: AppRouter.router,

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
        },
      ),
    );
  }
}
