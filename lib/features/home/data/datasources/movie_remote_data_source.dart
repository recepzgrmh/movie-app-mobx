import 'package:dio/dio.dart';
import '../../../../core/network/network_manager.dart';
import '../models/genre_model.dart';
import '../models/movie_response_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieResponseModel> getPopularMovies({int page = 1});
  Future<GenreResponseModel> getGenres();
  Future<MovieResponseModel> getMoviesByGenre(int genreId, {int page = 1});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final NetworkManager networkManager;

  MovieRemoteDataSourceImpl(this.networkManager);

  @override
  Future<MovieResponseModel> getPopularMovies({int page = 1}) async {
    try {
      final response = await networkManager.service.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );

      // Transforming V1 "results" to V2 "data.items" with renamed fields
      final v1Results = response.data['results'] as List;
      final v2Simulation = {
        'meta': {'status': 'success'},
        'data': {
          'items': v1Results
              .map(
                (m) => {
                  'id': m['id'],
                  'name': m['title'], // Renamed from title
                  'cover_url': m['poster_path'], // Renamed from poster_path
                  'rating': m['vote_average'], // Renamed from vote_average
                  'summary': m['overview'], // Renamed from overview

                  'backdrop_path': m['backdrop_path'],
                  'release_date': m['release_date'],
                  'genre_ids': m['genre_ids'],
                },
              )
              .toList(),
        },
      };

      return MovieResponseModel.fromJson(v2Simulation);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<GenreResponseModel> getGenres() async {
    try {
      final response = await networkManager.service.get('/genre/movie/list');
      return GenreResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<MovieResponseModel> getMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async {
    try {
      final response = await networkManager.service.get(
        '/discover/movie',
        queryParameters: {'with_genres': genreId, 'page': page},
      );
      return MovieResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
