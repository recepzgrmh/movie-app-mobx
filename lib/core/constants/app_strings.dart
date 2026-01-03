/// Application string constants
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'MovieApp';

  // Splash Screen
  static const String splashLoading = 'Loading...';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection.';
  static const String timeoutError = 'Request timed out. Please try again.';

  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String continueText = 'Continue';

  // Onboarding - Movies
  static const String onboardingMoviesTitle = 'Select Your Favorite Movies';
  static const String onboardingMoviesSubtitle = 'Choose up to 3 movies';
  static String onboardingMoviesSelected(int count) => '($count/3 selected)';

  // Onboarding - Genres
  static const String onboardingGenresTitle = 'Select Categories';
  static const String onboardingGenresSubtitle = 'Choose up to 2 categories';
  static String onboardingGenresSelected(int count) => '($count/2 selected)';
}

