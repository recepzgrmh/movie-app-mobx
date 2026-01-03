import '../../../../core/result/result.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetPopularMoviesUseCase {
  final MovieRepository repository;

  GetPopularMoviesUseCase(this.repository);

  Future<Result<List<MovieEntity>>> call({int page = 1}) {
    return repository.getPopularMovies(page: page);
  }
}
