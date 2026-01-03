import '../../../../core/result/result.dart';
import '../entities/genre_entity.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  /// Fetches popular movies with optional pagination
  Future<Result<List<MovieEntity>>> getPopularMovies({int page = 1});

  /// Fetches all available movie genres
  Future<Result<List<GenreEntity>>> getGenres();

  /// Fetches movies by genre ID with pagination
  Future<Result<List<MovieEntity>>> getMoviesByGenre(
    int genreId, {
    int page = 1,
  });

  /// Searches movies by query
  Future<Result<List<MovieEntity>>> searchMovies(String query, {int page = 1});
}
