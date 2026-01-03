import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/app/di/di.dart';
import 'package:movie_app/app/router/routes.dart';
import 'package:movie_app/core/constants/app_constants.dart';
import 'package:movie_app/core/constants/app_strings.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_dimens.dart';
import 'package:movie_app/core/widgets/movie_poster_card.dart';
import 'package:movie_app/features/home/domain/entities/genre_entity.dart';
import 'package:movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:movie_app/features/onboarding/presentation/stores/onboarding_store.dart';

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
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _store = getIt<OnboardingStore>();

    // Initialize store with data from splash
    _store.initWithData(widget.initialMovies, widget.initialGenres);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Load more 80% of the list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _store.loadMoreMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.onboardingMoviesTitle,
                    style: tt.headlineMedium,
                  ),
                  const SizedBox(height: 8),
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

            // Movie Grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = 16.0;
                  final spacing = 12.0;

                  // Ekranda 2 kart görünsün diye genişlik:
                  final itemWidth =
                      (constraints.maxWidth -
                          (horizontalPadding * 2) -
                          spacing) /
                      2;

                  final aspectRatio =
                      AppDimens.posterWidth / AppDimens.posterHeight;
                  final itemHeight = itemWidth / aspectRatio;

                  final topBump = 22.0;
                  final bottomDip = 18.0;
                  final topDip = 22.0;
                  return Observer(
                    builder: (_) => SizedBox(
                      height: itemHeight + topBump + bottomDip,
                      child: PhysicalShape(
                        clipper: ConcaveTopConcaveBottomClipper(
                          topDip: topDip,
                          bottomDip: bottomDip,
                        ),
                        color: Colors.transparent,
                        elevation: 10,
                        shadowColor: AppColors.black,
                        child: Container(
                          color: Theme.of(context).colorScheme.surface,
                          padding: EdgeInsets.only(
                            top: topBump,
                            bottom: bottomDip,
                          ),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                ...List.generate(_store.availableMovies.length, (
                                  index,
                                ) {
                                  final movie = _store.availableMovies[index];
                                  final isSelected = _store.isMovieSelected(
                                    movie,
                                  );

                                  return ClipPath(
                                    clipper: ConcaveTopConcaveBottomClipper(
                                      topDip: topDip,
                                      bottomDip: 18,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            index ==
                                                _store.availableMovies.length -
                                                    1
                                            ? 0
                                            : spacing,
                                      ),
                                      child: ClipPath(
                                        child: SizedBox(
                                          width: itemWidth,
                                          child: MoviePosterCard(
                                            imageUrl:
                                                '${AppConstants.imageBaseUrl}${movie.posterPath}',
                                            isSelected: isSelected,
                                            onTap: () => _store
                                                .toggleMovieSelection(movie),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),

                                if (_store.isLoadingMore) ...[
                                  const SizedBox(width: 12),
                                  const SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: tam olmadı bu kısım için düzenleme gerekiyor
class ConcaveTopConcaveBottomClipper extends CustomClipper<Path> {
  final double topDip; // üst çukur derinliği (içe)
  final double bottomDip; // alt çukur derinliği (içe)

  ConcaveTopConcaveBottomClipper({this.topDip = 24, this.bottomDip = 24});

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final p = Path();

    // ÜST: konkav (içe çukur)
    p.moveTo(0, 0);
    p.quadraticBezierTo(w / 2, topDip * 2, w, 0);

    // sağ kenar aşağı
    p.lineTo(w, h - bottomDip);

    // ALT: konkav (içe çukur)
    p.quadraticBezierTo(w / 2, h - (bottomDip * 2), 0, h - bottomDip);

    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant ConcaveTopConcaveBottomClipper old) =>
      old.topDip != topDip || old.bottomDip != bottomDip;
}
