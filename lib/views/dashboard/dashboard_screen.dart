import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habitflow/views/dashboard/widgets/progress_card.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_event.dart';
import '../../controllers/auth/auth_state.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/week_calendar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton.icon(
                //     onPressed: () {
                //       context.read<AuthBloc>().add(const LogoutRequested());
                //     },
                //     icon: const Icon(Icons.logout_rounded),
                //     label: const Text("Logout"),
                //   ),
                // ),

                const DashboardHeader(),

                SizedBox(height: AppSpacing.xl),

                const ProgressCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
