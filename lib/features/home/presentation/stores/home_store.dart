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
  String? errorMessage;

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
        success: (data) async {
          genres = ObservableList.of(data);
          // Fetch movies for all genres
          await _fetchAllCategoryMovies();
        },
        error: (failure) {
          errorMessage = failure.message;
        },
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _fetchAllCategoryMovies() async {
    for (final genre in genres) {
      final result = await _getMoviesByGenreUseCase(genre.id);
      result.when(
        success: (data) {
          moviesByCategory[genre.id] = ObservableList.of(data);
        },
        error: (_) {
          // Silently ignore errors for individual categories
        },
      );
    }
  }

  @action
  void setSelectedCategoryIndex(int index) {
    selectedCategoryIndex = index;
  }
}

