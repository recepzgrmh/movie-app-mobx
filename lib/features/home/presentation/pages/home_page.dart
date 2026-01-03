import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../../../app/di/di.dart';
import '../../domain/entities/genre_entity.dart';
import 'package:movie_app/core/theme/app_colors.dart';
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
  static const double _stickyHeaderOffset = 250.0;

  @override
  void initState() {
    super.initState();
    _homeStore = getIt<HomeStore>();
    _homeStore.fetchInitialData();

    // Create keys when genres are loaded
    _genresDisposer = reaction((_) => _homeStore.genres.length, (length) {
      setState(() {
        for (int i = 0; i < length; i++) {
          if (!_sectionKeys.containsKey(i)) {
            _sectionKeys[i] = GlobalKey();
          }
        }
      });
    });

    // Add scroll listener after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_onScroll);
    });
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      return;
    }

    // Find which section is currently visible
    for (int i = 0; i < _homeStore.genres.length; i++) {
      final key = _sectionKeys[i];
      if (key?.currentContext == null) continue;

      final RenderBox? renderBox =
          key!.currentContext!.findRenderObject() as RenderBox?;

      if (renderBox == null || !renderBox.attached) continue;

      try {
        final position = renderBox.localToGlobal(Offset.zero);
        // Check if section is in view (considering sticky header constant)
        if (position.dy <= _stickyHeaderOffset &&
            position.dy >= -renderBox.size.height + _stickyHeaderOffset) {
          if (_homeStore.selectedCategoryIndex != i) {
            _homeStore.setSelectedCategoryIndex(i);
          }
          return;
        }
      } catch (e) {
        debugPrint("Scroll error: $e");
      }
    }
  }

  Future<void> _scrollToCategory(int index) async {
    if (!_sectionKeys.containsKey(index)) return;

    _isAutoScrolling = true;
    _homeStore.setSelectedCategoryIndex(index);

    final key = _sectionKeys[index];
    if (key?.currentContext != null) {
      try {
        await Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.1, // Offset for sticky header
        );
      } catch (e) {
        debugPrint("Scroll to category error: $e");
      }
    }

    // Reset auto-scrolling flag with a small buffer
    await Future.delayed(const Duration(milliseconds: 50));
    _isAutoScrolling = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Observer(
        builder: (context) {
          if (_homeStore.isLoading && _homeStore.genres.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.redLight),
            );
          }

          if (_homeStore.errorMessage != null && _homeStore.genres.isEmpty) {
            return Center(
              child: Text(
                _homeStore.errorMessage!,
                style: const TextStyle(color: AppColors.redLight),
              ),
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
                                "For You ",
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: _homeStore.forYouMovies.length,
                            itemBuilder: (context, index) {
                              final movie = _homeStore.forYouMovies[index];
                              return Container(
                                margin: const EdgeInsets.only(right: 16),
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
                        const SizedBox(height: 24),
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
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              "Movies ",
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            Text("🎬", style: TextStyle(fontSize: 28)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
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
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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

                SliverToBoxAdapter(
                  child: Column(
                    children: List.generate(_homeStore.genres.length, (index) {
                      final genre = _homeStore.genres[index];
                      final movies =
                          _homeStore.moviesByCategory[genre.id]?.toList() ?? [];

                      return Container(
                        key: _sectionKeys[index],
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Text(
                                genre.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                scrollDirection: Axis.horizontal,

                                itemCount: movies.length > 9
                                    ? 9
                                    : movies.length,
                                itemBuilder: (context, movieIndex) {
                                  final movie = movies[movieIndex];
                                  return Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: AppColors.gray,
                                      borderRadius: BorderRadius.circular(12),
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
                          ],
                        ),
                      );
                    }),
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onCategoryTap(index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.redLight : AppColors.gray,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    const Icon(Icons.check, color: AppColors.white, size: 16),
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
