import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class NetworkManager {
  late final Dio _dio;

  NetworkManager() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(
          seconds: 10,
        ), // 10 sn cevap gelmezse patlasın
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Authorization':
              'Bearer ${AppConstants.apiKey}', // Token otomatik ekleniyor
          'Content-Type': 'application/json',
        },
      ),
    );

    // Konsolda request/response görmek için
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // Dışarıdan erişmek için getter
  Dio get service => _dio;
}
