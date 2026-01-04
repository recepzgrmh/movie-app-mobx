import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:movie_app/app/di/di.dart';
import '../../domain/entities/genre_entity.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_dimens.dart';
import 'package:movie_app/core/constants/app_strings.dart';
import 'package:movie_app/core/widgets/error_view.dart';
import 'package:movie_app/features/home/presentation/stores/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore _homeStore;
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {};
  bool _isAutoScrolling = false;
  late ReactionDisposer _genresDisposer;

  static const double _forYouSectionHeight =
      190.0; // Title + circle list + spacing
  static const double _moviesHeaderHeight = 120.0; // Title + search + spacing
  static const double _sectionHeaderHeight =
      AppDimens.spacing60; // Genre title + spacing (24 + 24 + 12)
  static const double _gridSpacing = AppDimens.spacing12;

  @override
  void initState() {
    super.initState();
    _homeStore = getIt<HomeStore>();

    // Only fetch if data wasn't already loaded from splash
    if (!_homeStore.isDataLoaded) {
      _homeStore.fetchInitialData();
    }

    // Reaction to ensure keys are ready when genres load
    _genresDisposer = reaction((_) => _homeStore.genres.length, (length) {
      _ensureSectionKeys(length);
    });

    // Add scroll listener after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_onScroll);
    });
  }

  /// Ensures section keys exist for all genres
  void _ensureSectionKeys(int count) {
    for (int i = 0; i < count; i++) {
      _sectionKeys.putIfAbsent(i, () => GlobalKey());
    }
  }

  /// Gets or creates a section key for the given index
  GlobalKey _getSectionKey(int index) {
    return _sectionKeys.putIfAbsent(index, () => GlobalKey());
  }

  @override
  void dispose() {
    _genresDisposer();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isAutoScrolling || _homeStore.genres.isEmpty) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final currentIndex = _findCurrentCategoryIndex(
      _scrollController.position.pixels,
      screenWidth,
    );

    if (_homeStore.selectedCategoryIndex != currentIndex) {
      _homeStore.setSelectedCategoryIndex(currentIndex);
    }
  }

  /// Calculates the scroll offset for a given category index
  double _calculateScrollOffset(int index, double screenWidth) {
    // Calculate single item height based on aspect ratio (2/3) and screen width

    final availableWidth =
        screenWidth -
        (AppDimens.pagePaddingHorizontal * 2) -
        (_gridSpacing * 2); // padding + spacing
    final itemWidth = availableWidth / 3;
    final itemHeight =
        itemWidth * 1.5; // aspect ratio 2/3 means height = width * 1.5

    // Grid height for 3 rows with spacing
    final gridHeight = (itemHeight * 3) + (_gridSpacing * 2);

    // Total section height
    final sectionHeight = _sectionHeaderHeight + gridHeight;

    // Base offset (For You + Movies Header)
    final baseOffset = _forYouSectionHeight + _moviesHeaderHeight;

    // Calculate offset for the target category
    return baseOffset + (sectionHeight * index);
  }

  Future<void> _scrollToCategory(int index) async {
    if (index < 0 || index >= _homeStore.genres.length) return;

    _isAutoScrolling = true;
    _homeStore.setSelectedCategoryIndex(index);

    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = _calculateScrollOffset(index, screenWidth);

    // Clamp to max scroll extent
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

    await _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    // Reset auto-scrolling flag with a small buffer
    await Future.delayed(const Duration(milliseconds: 50));
    _isAutoScrolling = false;
  }

  /// Finds the current category index based on scroll position
  int _findCurrentCategoryIndex(double scrollPosition, double screenWidth) {
    final baseOffset = _forYouSectionHeight + _moviesHeaderHeight;

    if (scrollPosition < baseOffset) return 0;

    if (scrollPosition < baseOffset) return 0;

    final availableWidth =
        screenWidth -
        (AppDimens.pagePaddingHorizontal * 2) -
        (_gridSpacing * 2);
    final itemWidth = availableWidth / 3;
    final itemHeight = itemWidth * 1.5;
    final gridHeight = (itemHeight * 3) + (_gridSpacing * 2);
    final sectionHeight = _sectionHeaderHeight + gridHeight;

    final adjustedPosition = scrollPosition - baseOffset;
    final index = (adjustedPosition / sectionHeight).floor();

    return index.clamp(0, _homeStore.genres.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Observer(
        builder: (context) {
          // Show loading until all data including category movies are loaded
          if ((_homeStore.isLoading || _homeStore.isCategoryMoviesLoading) &&
              (_homeStore.genres.isEmpty ||
                  _homeStore.moviesByCategory.isEmpty)) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.redLight),
            );
          }

          if (_homeStore.errorMessage != null && _homeStore.genres.isEmpty) {
            return ErrorView(
              message: _homeStore.errorMessage,
              onRetry: () {
                _homeStore.fetchInitialData();
              },
            );
          }

          return SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // For You Section
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text(
                                "${AppStrings.homeForYou} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                              ),
                              Text("⭐", style: TextStyle(fontSize: 24)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.pagePaddingHorizontal,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: _homeStore.forYouMovies.length,
                            itemBuilder: (context, index) {
                              final movie = _homeStore.forYouMovies[index];
                              return Container(
                                margin: const EdgeInsets.only(
                                  right: AppDimens.spacing16,
                                ),
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.gray,
                                  image: movie.posterPath.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppDimens.spacing24),
                      ],
                    ),
                  ),
                ),

                // Movies Header & Search
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.pagePaddingHorizontal,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "${AppStrings.homeMovies} ",
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                            ),
                            Text("🎬", style: TextStyle(fontSize: 28)),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.spacing16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.pagePaddingHorizontal,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: AppStrings.homeSearchHint,
                            hintStyle: TextStyle(color: AppColors.grayDark),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.grayDark,
                            ),
                            suffixIcon: Icon(
                              Icons.mic,
                              color: AppColors.grayDark,
                            ),
                            filled: true,
                            fillColor: AppColors.gray,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spacing16),
                    ],
                  ),
                ),

                // Sticky Category Tabs
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CategoryTabsDelegate(
                    genres: _homeStore.genres.toList(),
                    selectedIndex: _homeStore.selectedCategoryIndex,
                    onCategoryTap: _scrollToCategory,
                  ),
                ),

                // All Category Sections
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final genre = _homeStore.genres[index];
                    final movies = _homeStore.moviesByCategory[genre.id];
                    final displayMovies = movies?.take(9).toList() ?? [];

                    return Container(
                      key: _getSectionKey(index),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.pagePaddingHorizontal,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppDimens.spacing24),
                          // Genre Header
                          Text(
                            genre.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                          ),
                          const SizedBox(height: AppDimens.spacing12),
                          // Movie Grid (3x3)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayMovies.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: _gridSpacing,
                                  mainAxisSpacing: _gridSpacing,
                                  childAspectRatio: 2 / 3,
                                ),
                            itemBuilder: (context, movieIndex) {
                              final movie = displayMovies[movieIndex];
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.gray,
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusMedium,
                                  ),
                                  image: movie.posterPath.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }, childCount: _homeStore.genres.length),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
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

// Sticky Header Delegate for Category Tabs
class _CategoryTabsDelegate extends SliverPersistentHeaderDelegate {
  final List<GenreEntity> genres;
  final int selectedIndex;
  final Function(int) onCategoryTap;

  _CategoryTabsDelegate({
    required this.genres,
    required this.selectedIndex,
    required this.onCategoryTap,
  });

  @override
  double get minExtent => 60.0;

  @override
  double get maxExtent => 60.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.black,
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingSmall),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.pagePaddingHorizontal,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onCategoryTap(index),
            child: Container(
              margin: const EdgeInsets.only(right: AppDimens.spacing8),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spacing20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.redLight : AppColors.gray,
                borderRadius: BorderRadius.circular(AppDimens.radiusXLarge),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: AppDimens.iconSmall,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    genre.name,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(_CategoryTabsDelegate oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.genres.length != genres.length;
  }
}
