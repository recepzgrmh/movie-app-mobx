import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Base URL
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api.themoviedb.org/3';

  // API Key
  static String get apiKey => dotenv.env['TMDB_TOKEN'] ?? '';

  // Image Base URL
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
}
