import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/app/di/di.dart';
import 'package:movie_app/app/router/routes.dart';
import 'package:movie_app/core/constants/app_constants.dart';
import 'package:movie_app/core/constants/app_strings.dart';

import 'package:movie_app/core/theme/app_dimens.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/widgets/movie_poster_card.dart';
import 'package:movie_app/features/home/domain/entities/genre_entity.dart';
import 'package:movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:movie_app/features/onboarding/presentation/stores/onboarding_store.dart';
import 'dart:math' as math;

class OnboardingMoviesPage extends StatefulWidget {
  final List<MovieEntity> initialMovies;
  final List<GenreEntity> initialGenres;

  const OnboardingMoviesPage({
    super.key,
    required this.initialMovies,
    required this.initialGenres,
  });

  @override
  State<OnboardingMoviesPage> createState() => _OnboardingMoviesPageState();
}

class _OnboardingMoviesPageState extends State<OnboardingMoviesPage> {
  late final OnboardingStore _store;
  late final PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _store = getIt<OnboardingStore>();

    // Initialize store with data from splash
    _store.initWithData(widget.initialMovies, widget.initialGenres);

    _pageController = PageController(
      viewportFraction: 0.55, // Yan kartların görünme oranı
      initialPage: 0,
    );

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });

      // Load more when approaching end
      if (_pageController.page != null &&
          _pageController.page! >= _store.availableMovies.length - 3) {
        _store.loadMoreMovies();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Observer(
        builder: (_) => ElevatedButton(
          onPressed: _store.canContinue
              ? () {
                  _store.setStep(OnboardingStep.genres);
                  context.go(AppRoutes.onboardingGenres);
                }
              : null,
          child: Text(AppStrings.continueText),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePaddingHorizontal,
                vertical: AppDimens.pagePaddingVertical,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.onboardingMoviesTitle,
                    style: tt.headlineMedium,
                  ),
                  const SizedBox(height: AppDimens.spacing8),
                  Observer(
                    builder: (_) => Text(
                      '${AppStrings.onboardingMoviesSubtitle} ${AppStrings.onboardingMoviesSelected(_store.selectedMovies.length)}',
                      style: tt.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Movie Carousel
            Expanded(
              child: Observer(
                builder: (_) => _store.availableMovies.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildCarousel(),
              ),
            ),

            // Page Indicators
            Observer(builder: (_) => _buildPageIndicators()),
            const SizedBox(height: AppDimens.spacing16),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = AppDimens.posterWidth / AppDimens.posterHeight;
        final itemHeight = constraints.maxHeight * 0.7;
        final itemWidth = itemHeight * aspectRatio;

        return SizedBox(
          height: itemHeight,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount:
                _store.availableMovies.length + (_store.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Loading indicator
              if (index >= _store.availableMovies.length) {
                return Center(child: CircularProgressIndicator(strokeWidth: 2));
              }

              final movie = _store.availableMovies[index];

              // Observer ile sarmalayarak MobX değişikliklerini anında yansıtıyoruz
              return Observer(
                builder: (_) {
                  final isSelected = _store.isMovieSelected(movie);
                  return _buildCarouselItem(
                    index: index,
                    movie: movie,
                    isSelected: isSelected,
                    itemWidth: itemWidth,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCarouselItem({
    required int index,
    required MovieEntity movie,
    required bool isSelected,
    required double itemWidth,
  }) {
    // Calculate transform based on position
    double value = _currentPage - index;
    double dist = value.abs();

    double scale = math.min(1.0, 0.80 + dist * 0.2);

    double opacity = math.max(0.4, 1 - dist * 0.6);

    // Rotation for 3D effect
    double rotation = value * 0.4; // Radians

    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        return Center(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(rotation)
              ..multiply(Matrix4.diagonal3Values(scale, scale, scale)), // Uniform scale
            child: Opacity(
              opacity: opacity,
              child: GestureDetector(
                onTap: () {
                  if (dist > 0.1) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _store.toggleMovieSelection(movie);
                  }
                },
                  child: Container(
                    width: itemWidth,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacing12,
                      vertical: AppDimens.spacing20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.3),
                          blurRadius: 20 * scale,
                          spreadRadius: 5 * scale,
                          offset: Offset(0, 10 * scale),
                        ),
                      ],
                    ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                    child: MoviePosterCard(
                      imageUrl:
                          '${AppConstants.imageBaseUrl}${movie.posterPath}',
                      isSelected: isSelected,
                      onTap: () => _store.toggleMovieSelection(movie),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicators() {
    final visibleCount = math.min(5, _store.availableMovies.length);
    final currentIndex = _currentPage.round();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(visibleCount, (index) {
          // Show indicators for current position ± 2
          final actualIndex = currentIndex - 2 + index;

          if (actualIndex < 0 || actualIndex >= _store.availableMovies.length) {
            return const SizedBox.shrink();
          }

          final isActive = actualIndex == currentIndex;
          final distance = (actualIndex - _currentPage).abs();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacing4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isActive
                  ? AppColors.redLight
                  : AppColors.redLight.withValues(
                      alpha: math.max(0.2, 1 - distance * 0.3),
                    ),
            ),
          );
        }),
      ),
    );
  }
}
