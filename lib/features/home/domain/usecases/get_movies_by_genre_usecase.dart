import '../../../../core/result/result.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

/// Use case for fetching movies by genre
class GetMoviesByGenreUseCase {
  final MovieRepository repository;

  GetMoviesByGenreUseCase(this.repository);

  Future<Result<List<MovieEntity>>> call(int genreId, {int page = 1}) {
    return repository.getMoviesByGenre(genreId, page: page);
  }
}
