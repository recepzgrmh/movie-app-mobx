import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/app/di/di.dart';
import 'package:movie_app/app/router/routes.dart';
import 'package:movie_app/core/constants/app_strings.dart';
import 'package:movie_app/core/theme/app_dimens.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/core/widgets/genre_card.dart';
import 'package:movie_app/core/widgets/page_header.dart';
import 'package:movie_app/features/onboarding/presentation/stores/onboarding_store.dart';

class OnboardingGenresPage extends StatefulWidget {
  const OnboardingGenresPage({super.key});

  @override
  State<OnboardingGenresPage> createState() => _OnboardingGenresPageState();
}

class _OnboardingGenresPageState extends State<OnboardingGenresPage> {
  late final OnboardingStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<OnboardingStore>();
    _store.setStep(OnboardingStep.genres);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: Observer(
        builder: (_) => ElevatedButton(
          onPressed: _store.canContinue
              ? () async {
                  // Capture navigation before async gap
                  final navigator = GoRouter.of(context);

                  // Save selections to local storage for personalization
                  await _store.saveSelectionsToStorage();

                  _store.setStep(OnboardingStep.paywall);
                  navigator.go(AppRoutes.paywall);
                }
              : null,
          child: Text(AppStrings.continueText),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // Header
            Observer(
              builder: (_) {
                final isCompleted = _store.selectedGenres.length >= 2;
                return PageHeader(
                  title: isCompleted
                      ? AppStrings.onboardingGenresTitleCompleted
                      : AppStrings.onboardingGenresTitle,
                  subtitle: isCompleted
                      ? ' '
                      : AppStrings.onboardingGenresSubtitle,
                  titleStyle: AppTypography.onboardingTitle,
                  subtitleStyle: AppTypography.onboardingSubtitle.copyWith(
                    color: isCompleted ? Colors.transparent : null,
                  ),
                  textAlign: .start,
                );
              },
            ),

            const SizedBox(height: AppDimens.spacing24),

            // Genre Grid
            Expanded(
              child: Observer(
                builder: (_) {
                  // Force MobX to observe selectedGenres changes
                  final _ = _store.selectedGenres.length;

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.pagePaddingHorizontal,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: AppDimens.spacing16,
                          mainAxisSpacing: AppDimens.spacing16,
                        ),
                    itemCount: _store.availableGenres.length,
                    itemBuilder: (context, index) {
                      final genre = _store.availableGenres[index];
                      final isSelected = _store.selectedGenres.any(
                        (g) => g.id == genre.id,
                      );

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GenreCard(
                            imageUrl:
                                genre.imageUrl ??
                                _getFallbackGenreImage(genre.id),
                            isSelected: isSelected,
                            onTap: () => _store.toggleGenreSelection(genre),
                          ),
                          const SizedBox(height: AppDimens.spacing8),
                          Text(
                            genre.name,
                            style: tt.bodyMedium,
                            textAlign: .center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fallback images for genres when dynamic image is not available
  String _getFallbackGenreImage(int genreId) {
    const fallbackImages = {
      28: 'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg', // Action
      12: 'https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg', // Adventure
      16: 'https://image.tmdb.org/t/p/w500/qsdjk9oAKSQMWs0Vt5Pyfh6O4GZ.jpg', // Animation
      35: 'https://image.tmdb.org/t/p/w500/tHpBoF8IAimHVQP0Hvgk6O2tUQ7.jpg', // Comedy
      80: 'https://image.tmdb.org/t/p/w500/5HnIhj3iOKZIiBqpGL3GvOxoDMf.jpg', // Crime
      99: 'https://image.tmdb.org/t/p/w500/1YjdSym1jTG7xjHSI0yGGWEsw5i.jpg', // Documentary
      18: 'https://image.tmdb.org/t/p/w500/l0qVZIpXtIo7km9u5Yqh0nKPOr5.jpg', // Drama
      10751:
          'https://image.tmdb.org/t/p/w500/kBf3g9crrADGMc2AMAMlLBgSm2h.jpg', // Family
      14: 'https://image.tmdb.org/t/p/w500/ygGmAO60t8GyqUo9xYeYxSZAR3b.jpg', // Fantasy
      36: 'https://image.tmdb.org/t/p/w500/sBp8EEWD1J1mvdbOl6Nt1kKAHO6.jpg', // History
      27: 'https://image.tmdb.org/t/p/w500/90ez6ArvpO8bvpyIngBuwXOqJm5.jpg', // Horror
      10402:
          'https://image.tmdb.org/t/p/w500/9rtrRGeRnL0JKtu9IMBWsmlmmZz.jpg', // Music
      9648:
          'https://image.tmdb.org/t/p/w500/7F8vH3hBJB6svEPBb3jKGJcq0Nw.jpg', // Mystery
      10749:
          'https://image.tmdb.org/t/p/w500/3Nz7SHdlVvY7g7ZY07Vw0WZC5Lx.jpg', // Romance
      878:
          'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', // Sci-Fi
      10770:
          'https://image.tmdb.org/t/p/w500/rLb2cwF3Pazuxaj0sRXQ037tGI1.jpg', // TV Movie
      53: 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg', // Thriller
      10752:
          'https://image.tmdb.org/t/p/w500/s5HTrIrAVQmQP5jijyBPPe9Rlqn.jpg', // War
      37: 'https://image.tmdb.org/t/p/w500/xKb6mtdfI5Qsggc44Hr9CCUDvAj.jpg', // Western
    };
    return fallbackImages[genreId] ??
        'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg';
  }
}
