import 'package:mobx/mobx.dart';
import '../../../home/domain/entities/genre_entity.dart';
import '../../../home/domain/entities/movie_entity.dart';
import '../../../home/domain/usecases/get_genres_usecase.dart';
import '../../../home/domain/usecases/get_popular_movies_usecase.dart';

part 'splash_store.g.dart';

class SplashStore = _SplashStore with _$SplashStore;

abstract class _SplashStore with Store {
  final GetPopularMoviesUseCase getPopularMoviesUseCase;
  final GetGenresUseCase getGenresUseCase;

  _SplashStore({
    required this.getPopularMoviesUseCase,
    required this.getGenresUseCase,
  });

  @observable
  bool isLoading = false;

  @observable
  bool isInitialized = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<MovieEntity> popularMovies = ObservableList<MovieEntity>();

  @observable
  ObservableList<GenreEntity> genres = ObservableList<GenreEntity>();

  @action
  Future<void> init() async {
    isLoading = true;
    errorMessage = null;

    try {
      // Fetch popular movies and genres in parallel
      final results = await Future.wait([
        getPopularMoviesUseCase(),
        getGenresUseCase(),
      ]);

      // Handle movies result
      results[0].when(
        success: (data) => popularMovies.addAll(data as List<MovieEntity>),
        error: (failure) => errorMessage = failure.message,
      );

      // Handle genres result
      results[1].when(
        success: (data) => genres.addAll(data as List<GenreEntity>),
        error: (failure) => errorMessage ??= failure.message,
      );

      // Only mark as initialized if no errors
      if (errorMessage == null) {
        isInitialized = true;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}

