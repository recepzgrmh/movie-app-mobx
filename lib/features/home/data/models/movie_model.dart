import 'package:movie_app/features/home/domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.genreIds,
    required super.overview,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      
      // Adapt title -> name
      title: json['title'] ?? json['name'] ?? '',
      
      // Adapt poster_path -> cover_url
      posterPath: json['poster_path'] ?? json['cover_url'] ?? '',
      
      backdropPath: json['backdrop_path'] ?? '',
      
      // Adapt vote_average -> rating
      voteAverage: (json['vote_average'] ?? json['rating'] as num?)?.toDouble() ?? 0.0,
      
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids']?.map((x) => x) ?? []),
      
      // Adapt overview -> summary
      overview: json['overview'] ?? json['summary'] ?? '',
    );
  }
}
