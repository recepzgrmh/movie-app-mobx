import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:movie_app/app/di/di.dart';
import 'package:movie_app/app/router/app_router.dart';
import 'package:movie_app/app/router/routes.dart';
import 'package:movie_app/core/constants/app_strings.dart';
import 'package:movie_app/core/constants/app_constants.dart';
import 'package:movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:movie_app/features/home/presentation/stores/home_store.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_dimens.dart';
import 'package:movie_app/core/widgets/error_view.dart';
import 'package:movie_app/features/splash/presentation/stores/splash_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashStore _store;

  ReactionDisposer? _readyDisposer;
  ReactionDisposer? _errorDisposer;

  @override
  void initState() {
    super.initState();

    _store = getIt<SplashStore>();
    _store.init();

    _readyDisposer = reaction<bool>(((_) => _store.isInitialized), (
      ready,
    ) async {
      if (!ready || !mounted) return;

      // Precache images for onboarding screens
      await _precacheImages();

      if (!mounted) return;

      // Set data to HomeStore before navigation
      final homeStore = getIt<HomeStore>();
      homeStore.setInitialData(
        popularMovies: _store.popularMovies.toList(),
        genresList: _store.genres.toList(),
        categoryMovies: Map<int, List<MovieEntity>>.from(
          _store.moviesByCategory,
        ),
      );

      // Personalize For You section based on saved genre preferences
      homeStore.personalizeForYou();

      context.go(
        AppRoutes.onboarding,
        extra: OnboardingRouteData(
          movies: _store.popularMovies.toList(),
          genres: _store.genres.toList(),
        ),
      );
    });

    _errorDisposer = reaction<String?>((_) => _store.errorMessage, (msg) {
      if (msg == null || !mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redLight,
          content: Text(msg, style: TextStyle(color: AppColors.white)),
        ),
      );
    });
  }

  Future<void> _precacheImages() async {
    final futures = <Future>[];

    for (final movie in _store.popularMovies.take(20)) {
      if (movie.posterPath.isNotEmpty) {
        futures.add(
          precacheImage(
            NetworkImage('${AppConstants.imageBaseUrl}${movie.posterPath}'),
            context,
          ).catchError((_) {}),
        );
      }
    }

    for (final genre in _store.genres) {
      if (genre.imageUrl != null && genre.imageUrl!.isNotEmpty) {
        futures.add(
          precacheImage(
            NetworkImage(genre.imageUrl!),
            context,
          ).catchError((_) {}),
        );
      }
    }

    for (final entry in _store.moviesByCategory.entries) {
      final movies = entry.value;
      for (final movie in movies.take(3)) {
        if (movie.posterPath.isNotEmpty) {
          futures.add(
            precacheImage(
              NetworkImage('${AppConstants.imageBaseUrl}${movie.posterPath}'),
              context,
            ).catchError((_) {}),
          );
        }
      }
    }

    for (final movie in _store.popularMovies.take(10)) {
      if (movie.posterPath.isNotEmpty) {
        // Precache smaller size for circular avatars
        futures.add(
          precacheImage(
            NetworkImage('https://image.tmdb.org/t/p/w200${movie.posterPath}'),
            context,
          ).catchError((_) {}),
        );
      }
    }

    // Wait with timeout to avoid blocking too long
    await Future.wait(
      futures,
    ).timeout(const Duration(seconds: 8), onTimeout: () => []);
  }

  @override
  void dispose() {
    _readyDisposer?.call();
    _errorDisposer?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      body: Observer(
        builder: (_) {
          // Show error state with retry button
          if (_store.errorMessage != null && !_store.isLoading) {
            return ErrorView(
              message: _store.errorMessage,
              onRetry: () {
                _store.init();
              },
            );
          }

          // Normal loading state
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AppLogoCard(),
                const SizedBox(height: AppDimens.spacing24),
                Text(
                  AppStrings.appName,
                  textAlign: .center,
                  style: (tt.headlineLarge ?? const TextStyle()).copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: AppDimens.spacing20),
                AnimatedOpacity(
                  opacity: _store.isLoading ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AppLogoCard extends StatelessWidget {
  const _AppLogoCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166,
      height: 166,
      child: Center(child: Image.asset('assets/icons/movie_app.png')),
    );
  }
}
