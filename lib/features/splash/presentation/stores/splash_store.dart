import 'package:mobx/mobx.dart';
import 'package:movie_app/core/constants/app_constants.dart';
import 'package:movie_app/core/result/result.dart';
import '../../../home/data/models/genre_model.dart';
import '../../../home/domain/entities/genre_entity.dart';
import '../../../home/domain/entities/movie_entity.dart';
import '../../../home/domain/usecases/get_genres_usecase.dart';
import '../../../home/domain/usecases/get_movies_by_genre_usecase.dart';
import '../../../home/domain/usecases/get_popular_movies_usecase.dart';

import '../../../paywall/domain/usecases/get_paywall_config_usecase.dart';

part 'splash_store.g.dart';

class SplashStore = _SplashStore with _$SplashStore;

abstract class _SplashStore with Store {
  final GetPopularMoviesUseCase getPopularMoviesUseCase;
  final GetGenresUseCase getGenresUseCase;
  final GetMoviesByGenreUseCase getMoviesByGenreUseCase;
  final GetPaywallConfigUseCase getPaywallConfigUseCase;

  _SplashStore({
    required this.getPopularMoviesUseCase,
    required this.getGenresUseCase,
    required this.getMoviesByGenreUseCase,
    required this.getPaywallConfigUseCase,
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

  @observable
  ObservableMap<int, List<MovieEntity>> moviesByCategory = ObservableMap<int, List<MovieEntity>>();

  @action
  Future<void> init() async {
    isLoading = true;
    errorMessage = null;

    try {
      // Fetch popular movies, genres AND paywall config in parallel
      final results = await Future.wait([
        getPopularMoviesUseCase(),
        getGenresUseCase(),
        getPaywallConfigUseCase(), // Prefetch paywall config
      ]);

      // Handle movies result
      (results[0] as Result<List<MovieEntity>>).when(
        success: (data) => popularMovies.addAll(data),
        error: (failure) => errorMessage = failure.message,
      );

      // Handle genres result
      (results[1] as Result<List<GenreEntity>>).when(
        success: (data) => genres.addAll(data),
        error: (failure) => errorMessage ??= failure.message,
      );

      // Fetch movies for all genres in parallel
      if (genres.isNotEmpty) {
        await _fetchAllCategoryMovies();
        // Assign dynamic images to genres based on first movie poster
        _assignGenreImages();
      }

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

  @action
  Future<void> _fetchAllCategoryMovies() async {
    final futures = genres.map((genre) async {
      final result = await getMoviesByGenreUseCase(genre.id);
      result.when(
        success: (data) {
          moviesByCategory[genre.id] = data;
        },
        error: (_) {
          // Silently ignore errors for individual categories
        },
      );
    });
    
    await Future.wait(futures);
  }

  /// Assigns dynamic images to genres based on first movie poster from each category
  @action
  void _assignGenreImages() {
    final updatedGenres = <GenreEntity>[];
    
    for (final genre in genres) {
      final movies = moviesByCategory[genre.id];
      String? imageUrl;
      
      // Get poster from first movie with a valid poster path
      if (movies != null && movies.isNotEmpty) {
        for (final movie in movies.take(5)) {
          if (movie.posterPath.isNotEmpty) {
            imageUrl = '${AppConstants.imageBaseUrl}${movie.posterPath}';
            break;
          }
        }
      }
      
      // Create updated genre with imageUrl
      if (genre is GenreModel) {
        updatedGenres.add(genre.copyWithImage(imageUrl));
      } else {
        updatedGenres.add(GenreEntity(
          id: genre.id,
          name: genre.name,
          imageUrl: imageUrl,
        ));
      }
    }
    
    genres.clear();
    genres.addAll(updatedGenres);
  }
}


