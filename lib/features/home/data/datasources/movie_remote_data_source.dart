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
      return MovieResponseModel.fromJson(response.data);
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
  Future<MovieResponseModel> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await networkManager.service.get(
        '/discover/movie',
        queryParameters: {
          'with_genres': genreId,
          'page': page,
        },
      );
      return MovieResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}

