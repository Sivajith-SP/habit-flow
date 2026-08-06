import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_curves.dart';
import '../../app/theme/app_durations.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../auth/widgets/auth_background.dart';
import 'onboarding_items.dart';
import 'widgets/onboarding_bottom_bar.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  double _currentPageValue = 0.0;
  int get _currentPage => _currentPageValue.round();
  bool get _isLastPage => _currentPage == onboardingItems.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_isLastPage) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.hasSeenOnboarding, true);

      if (!mounted) return;
      context.go(AppRoutes.login);
      return;
    }

    _pageController.nextPage(
      duration: AppDurations.normal,
      curve: AppCurves.standard,
    );
  }

  void _skip() {
    _pageController.animateToPage(
      onboardingItems.length - 1,
      duration: AppDurations.normal,
      curve: AppCurves.emphasized,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Top App Bar with Skip button on top right
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: AnimatedOpacity(
                  opacity: _isLastPage ? 0.0 : 1.0,
                  duration: AppDurations.normal,
                  child: IgnorePointer(
                    ignoring: _isLastPage,
                    child: TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Skip",
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // PageView containing illustration and title/subtitle bottom-aligned
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingItems.length,
                itemBuilder: (context, index) {
                  final pageOffset = index - _currentPageValue;
                  return OnboardingPage(
                    item: onboardingItems[index],
                    pageOffset: pageOffset,
                  );
                },
              ),
            ),

            // Fixed Page Indicator & Bottom Full-Width Pill Action Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: AppSpacing.lg),

                  // Fixed Page Indicator Dots directly above bottom CTA button
                  PageIndicator(
                    pageValue: _currentPageValue,
                    itemCount: onboardingItems.length,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Fixed Bottom Action Button
                  OnboardingBottomBar(
                    isLastPage: _isLastPage,
                    onSkip: _skip,
                    onNext: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
