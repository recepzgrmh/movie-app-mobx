import 'package:dio/dio.dart';
import '../../../../core/network/network_manager.dart'; // Yolu kendine göre ayarla
import '../models/movie_response_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieResponseModel> getPopularMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final NetworkManager networkManager;

  MovieRemoteDataSourceImpl(this.networkManager);

  @override
  Future<MovieResponseModel> getPopularMovies() async {
    try {
      // Endpoint: /movie/popular
      final response = await networkManager.service.get('/movie/popular');

      return MovieResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
