import 'package:go_router/go_router.dart';
import 'package:movie_app/features/home/domain/entities/genre_entity.dart';
import 'package:movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:movie_app/features/home/presentation/pages/home_page.dart';
import 'package:movie_app/features/onboarding/presentation/pages/onboarding_genres_page.dart';
import 'package:movie_app/features/onboarding/presentation/pages/onboarding_movies_page.dart';

import 'package:movie_app/features/paywall/presentation/pages/paywall_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'routes.dart';

class OnboardingRouteData {
  final List<MovieEntity> movies;
  final List<GenreEntity> genres;

  OnboardingRouteData({required this.movies, required this.genres});
}

/// Application router configuration using go_router
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) {
          final data = state.extra as OnboardingRouteData;
          return OnboardingMoviesPage(
            initialMovies: data.movies,
            initialGenres: data.genres,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboardingGenres,
        name: 'onboarding-genres',
        builder: (context, state) => const OnboardingGenresPage(),
      ),
      GoRoute(
        path: AppRoutes.paywall,
        name: 'paywall',
        builder: (context, state) => const PaywallPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
