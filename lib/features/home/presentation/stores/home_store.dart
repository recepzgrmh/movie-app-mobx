import 'package:mobx/mobx.dart';
import '../../domain/entities/genre_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_genres_usecase.dart';
import '../../domain/usecases/get_movies_by_genre_usecase.dart';
import '../../domain/usecases/get_popular_movies_usecase.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final GetPopularMoviesUseCase _getPopularMoviesUseCase;
  final GetGenresUseCase _getGenresUseCase;
  final GetMoviesByGenreUseCase _getMoviesByGenreUseCase;

  _HomeStore({
    required GetPopularMoviesUseCase getPopularMoviesUseCase,
    required GetGenresUseCase getGenresUseCase,
    required GetMoviesByGenreUseCase getMoviesByGenreUseCase,
  })  : _getPopularMoviesUseCase = getPopularMoviesUseCase,
        _getGenresUseCase = getGenresUseCase,
        _getMoviesByGenreUseCase = getMoviesByGenreUseCase;

  @observable
  ObservableList<MovieEntity> forYouMovies = ObservableList<MovieEntity>();

  @observable
  ObservableList<GenreEntity> genres = ObservableList<GenreEntity>();

  @observable
  ObservableMap<int, ObservableList<MovieEntity>> moviesByCategory = ObservableMap<int, ObservableList<MovieEntity>>();

  @observable
  int selectedCategoryIndex = 0;

  @observable
  bool isLoading = false;

  @observable
  bool isCategoryMoviesLoading = false;

  @observable
  bool isDataLoaded = false;

  @observable
  String? errorMessage;

  /// Sets initial data from splash screen to avoid re-fetching
  @action
  void setInitialData({
    required List<MovieEntity> popularMovies,
    required List<GenreEntity> genresList,
    required Map<int, List<MovieEntity>> categoryMovies,
  }) {
    if (isDataLoaded) return; // Already loaded, skip
    
    forYouMovies = ObservableList.of(popularMovies);
    genres = ObservableList.of(genresList);
    
    for (final entry in categoryMovies.entries) {
      moviesByCategory[entry.key] = ObservableList.of(entry.value);
    }
    
    isDataLoaded = true;
  }

  @action
  Future<void> fetchInitialData() async {
    isLoading = true;
    errorMessage = null;

    try {
      // Fetch For You (Popular) Movies
      final popularResult = await _getPopularMoviesUseCase();
      popularResult.when(
        success: (data) {
          forYouMovies = ObservableList.of(data);
        },
        error: (failure) {
          errorMessage = failure.message;
        },
      );

      // Fetch Genres
      final genresResult = await _getGenresUseCase();
      genresResult.when(
        success: (data) {
          genres = ObservableList.of(data);
        },
        error: (failure) {
          errorMessage = failure.message;
        },
      );

      // Fetch movies for all genres (parallel loading)
      if (genres.isNotEmpty) {
        await _fetchAllCategoryMovies();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _fetchAllCategoryMovies() async {
    isCategoryMoviesLoading = true;
    
    // Fetch all categories in parallel for faster loading
    final futures = genres.map((genre) async {
      final result = await _getMoviesByGenreUseCase(genre.id);
      result.when(
        success: (data) {
          moviesByCategory[genre.id] = ObservableList.of(data);
        },
        error: (_) {
          // Silently ignore errors for individual categories
        },
      );
    });
    
    await Future.wait(futures);
    isCategoryMoviesLoading = false;
  }

  @action
  void setSelectedCategoryIndex(int index) {
    selectedCategoryIndex = index;
  }
}

