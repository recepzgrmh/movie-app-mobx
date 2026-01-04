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

  /// Precaches movie posters and genre images for onboarding screens
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

    await Future.wait(
      futures,
    ).timeout(const Duration(seconds: 5), onTimeout: () => []);
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _AppLogoCard(),
            const SizedBox(height: AppDimens.spacing24),
            Text(
              AppStrings.appName,
              textAlign: TextAlign.center,
              style: (tt.headlineLarge ?? const TextStyle()).copyWith(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: AppDimens.spacing20),
            Observer(
              builder: (_) => AnimatedOpacity(
                opacity: _store.isLoading ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ],
        ),
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
