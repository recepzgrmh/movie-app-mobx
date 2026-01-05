import 'movie_model.dart';

class MovieResponseModel {
  final List<MovieModel> results;

  MovieResponseModel({required this.results});

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) {
    // 1. Detect V2 Structure (data -> items)
    final v2Items = json['data']?['items'];
    
    // 2. Fallback to V1 Structure (results)
    final v1Results = json['results'];

    final listToParse = v2Items ?? v1Results ?? [];

    return MovieResponseModel(
      results: List<MovieModel>.from(
        (listToParse as List).map((x) => MovieModel.fromJson(x)),
      ),
    );
  }
}
