import 'movie_model.dart';

class MovieResponseModel {
  final List<MovieModel> results;

  MovieResponseModel({required this.results});

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieResponseModel(
      results: json['results'] != null
          ? List<MovieModel>.from(
              (json['results'] as List).map((x) => MovieModel.fromJson(x)),
            )
          : [],
    );
  }
}
