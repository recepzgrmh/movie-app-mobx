import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:movie_app/app/di/di.dart';
import 'package:movie_app/app/router/app_router.dart';
import 'package:movie_app/app/router/routes.dart';
import 'package:movie_app/core/constants/app_strings.dart';
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

    _readyDisposer = reaction<bool>((_) => _store.isInitialized, (ready) {
      if (!ready || !mounted) return;
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

      final cs = Theme.of(context).colorScheme;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: cs.error, // veya AppColors.redLight
          content: Text(msg, style: TextStyle(color: cs.onError)),
        ),
      );
    });
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
            const SizedBox(height: 26),
            Text(
              AppStrings.appName,
              textAlign: TextAlign.center,
              style: (tt.headlineLarge ?? const TextStyle()).copyWith(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 22),
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
