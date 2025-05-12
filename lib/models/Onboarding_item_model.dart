class OnboardingItem {
  final String title;
  final String description;
  final String lottieAnimationPath;
  final bool isLottie;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.lottieAnimationPath,
    this.isLottie = true,
  });
}
