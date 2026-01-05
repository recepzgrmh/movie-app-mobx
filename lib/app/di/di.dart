import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../../core/network/network_manager.dart';
import '../../core/services/local_storage_service.dart';

// Data Layer
import '../../features/home/data/datasources/movie_remote_data_source.dart';
import '../../features/home/data/movie_repository_impl.dart';

// Domain Layer
import '../../features/home/domain/repositories/movie_repository.dart';
import '../../features/home/domain/usecases/get_genres_usecase.dart';
import '../../features/home/domain/usecases/get_movies_by_genre_usecase.dart';
import '../../features/home/domain/usecases/get_popular_movies_usecase.dart';

import '../../features/paywall/data/repositories/paywall_config_repository_impl.dart';
import '../../features/paywall/domain/repositories/paywall_config_repository.dart';
import '../../features/paywall/domain/usecases/get_paywall_config_usecase.dart';

// Presentation Layer - Stores
import '../../features/onboarding/presentation/stores/onboarding_store.dart';
import '../../features/paywall/presentation/stores/paywall_store.dart';
import '../../features/splash/presentation/stores/splash_store.dart';
import '../../features/home/presentation/stores/home_store.dart';

final getIt = GetIt.instance;

/// Initialize dependencies that require async initialization
Future<void> initializeDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(getIt<SharedPreferences>()),
  );
}

void configureDependencies() {
  // ─────────────────────────────────────────────────────────────────────────────
  // CORE
  // ─────────────────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<NetworkManager>(() => NetworkManager());

  // ─────────────────────────────────────────────────────────────────────────────
  // DATA LAYER - Data Sources
  // ─────────────────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getIt<NetworkManager>()),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // DATA LAYER - Repositories
  // ─────────────────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(getIt<MovieRemoteDataSource>()),
  );

  getIt.registerLazySingleton<PaywallConfigRepository>(
    () => PaywallConfigRepositoryImpl(),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // DOMAIN LAYER - Use Cases
  // ─────────────────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<GetPopularMoviesUseCase>(
    () => GetPopularMoviesUseCase(getIt<MovieRepository>()),
  );

  getIt.registerLazySingleton<GetGenresUseCase>(
    () => GetGenresUseCase(getIt<MovieRepository>()),
  );

  getIt.registerLazySingleton<GetMoviesByGenreUseCase>(
    () => GetMoviesByGenreUseCase(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<GetPaywallConfigUseCase>(
    () => GetPaywallConfigUseCase(getIt<PaywallConfigRepository>()),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // PRESENTATION LAYER - Stores
  // ─────────────────────────────────────────────────────────────────────────────
  getIt.registerFactory<SplashStore>(
    () => SplashStore(
      getPopularMoviesUseCase: getIt<GetPopularMoviesUseCase>(),
      getGenresUseCase: getIt<GetGenresUseCase>(),
      getMoviesByGenreUseCase: getIt<GetMoviesByGenreUseCase>(),
      getPaywallConfigUseCase: getIt<GetPaywallConfigUseCase>(),
    ),
  );

  getIt.registerFactory<PaywallStore>(
    () => PaywallStore(
      getPaywallConfigUseCase: getIt<GetPaywallConfigUseCase>(),
    ),
  );

  // OnboardingStore as singleton - shared across onboarding screens
  getIt.registerLazySingleton<OnboardingStore>(
    () => OnboardingStore(
      getPopularMoviesUseCase: getIt<GetPopularMoviesUseCase>(),
      localStorageService: getIt<LocalStorageService>(),
    ),
  );

  // HomeStore as singleton - data is shared and persisted across navigation
  getIt.registerLazySingleton<HomeStore>(
    () => HomeStore(
      getPopularMoviesUseCase: getIt<GetPopularMoviesUseCase>(),
      getGenresUseCase: getIt<GetGenresUseCase>(),
      getMoviesByGenreUseCase: getIt<GetMoviesByGenreUseCase>(),
      localStorageService: getIt<LocalStorageService>(),
    ),
  );
}

