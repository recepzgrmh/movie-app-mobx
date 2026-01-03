import '../../../../core/result/result.dart';
import '../entities/genre_entity.dart';
import '../repositories/movie_repository.dart';

/// Use case for fetching all movie genres
class GetGenresUseCase {
  final MovieRepository repository;

  GetGenresUseCase(this.repository);

  Future<Result<List<GenreEntity>>> call() {
    return repository.getGenres();
  }
}
