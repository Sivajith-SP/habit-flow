/// Model representing one onboarding page.
class OnboardingItem {
  final String title;
  final String subtitle;
  final String animation;

  const OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.animation,
  });
}

const onboardingItems = [
  OnboardingItem(
    title: "Welcome to HabitFlow",
    subtitle: "Small habits lead to big transformations.",
    animation: "assets/lottie/welcome.json",
  ),

  OnboardingItem(
    title: "Track Every Day",
    subtitle: "Build consistency with simple daily habits.",
    animation: "assets/lottie/tracking.json",
  ),

  OnboardingItem(
    title: "Stay Motivated",
    subtitle: "Celebrate every milestone and never lose your streak.",
    animation: "assets/lottie/success.json",
  ),
];