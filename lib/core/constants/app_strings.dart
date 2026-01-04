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

  // Home Page
  static const String homeForYou = 'For You';
  static const String homeMovies = 'Movies';
  static const String homeSearchHint = 'Search';

  // Onboarding - Movies
  static const String onboardingMoviesTitle = 'Select Your Favorite Movies';
  static const String onboardingMoviesSubtitle = 'Choose up to 3 movies';
  static String onboardingMoviesSelected(int count) => '($count/3 selected)';

  // Onboarding - Genres
  static const String onboardingGenresTitle = 'Select Categories';
  static const String onboardingGenresSubtitle = 'Choose up to 2 categories';
  static String onboardingGenresSelected(int count) => '($count/2 selected)';
  // Paywall - General
  static const String enableFreeTrial = 'Enable Free Trial';
  static const String restorePurchase = 'Restore Purchase';
  static const String termsOfUse = 'Terms of Use';
  static const String privacyPolicy = 'Privacy Policy';
  static const String autoRenewable = 'Auto Renewable, Cancel Anytime';
  static const String bestValue = 'Best Value';
  static const String free = 'FREE';
  static const String pro = 'PRO';

  // Paywall - Features
  static const String dailyMovieSuggestions = 'Daily Movie Suggestions';
  static const String aiPoweredInsights = 'AI-Powered Movie Insights';
  static const String personalizedWatchlists = 'Personalized Watchlists';
  static const String adFreeExperience = 'Ad-Free Experience';

  // Paywall - Button
  static const String unlockMovieAiPro = 'Unlock MovieAI PRO';
  static const String threeDaysFree = '3 Days Free';
  static const String noPaymentNow = 'No Payment Now';

  // Paywall - Subscriptions
  static const String weekly = 'Weekly';
  static const String monthly = 'Monthly';
  static const String yearly = 'Yearly';
  static const String only = 'Only';
  static const String perWeek = 'per week';
  static const String perMonth = 'per month';
  static const String perYear = 'per year';

  static String pricePerWeek(String price) => '$price / week';
  static String pricePerMonth(String price) => '$price / month';
  static String pricePerYear(String price) => '$price / year';
  static String onlyPricePerWeek(String price) => 'Only $price per week';
}

