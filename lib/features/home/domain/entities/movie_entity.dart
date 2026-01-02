import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final int id;
  final String title;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;
  final String overview;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    required this.overview,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    posterPath,
    backdropPath,
    voteAverage,
    releaseDate,
    genreIds,
    overview,
  ];
}
