import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../core/result/result.dart';
import '../domain/entities/genre_entity.dart';
import '../domain/entities/movie_entity.dart';
import '../domain/repositories/movie_repository.dart';
import 'datasources/movie_remote_data_source.dart';

/// Implementation of MovieRepository
/// Handles data fetching and error conversion
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<MovieEntity>>> getPopularMovies({int page = 1}) async {
    try {
      final response = await remoteDataSource.getPopularMovies(page: page);
      return Success(response.results);
    } catch (e) {
      return Error(_handleError(e));
    }
  }

  @override
  Future<Result<List<GenreEntity>>> getGenres() async {
    try {
      final response = await remoteDataSource.getGenres();
      return Success(response.genres);
    } catch (e) {
      return Error(_handleError(e));
    }
  }

  @override
  Future<Result<List<MovieEntity>>> getMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async {
    try {
      final response = await remoteDataSource.getMoviesByGenre(
        genreId,
        page: page,
      );
      return Success(response.results);
    } catch (e) {
      return Error(_handleError(e));
    }
  }

  @override
  Future<Result<List<MovieEntity>>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    // TODO
    return const Error(UnknownFailure(message: 'Not implemented'));
  }

  Failure _handleError(Object e) {
    if (e is AppException) {
      return failureFrom(e);
    }
    return UnknownFailure(message: e.toString());
  }
}
