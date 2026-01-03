import 'package:get_it/get_it.dart';

// Core
import '../../core/network/network_manager.dart';

// Data Layer
import '../../features/home/data/datasources/movie_remote_data_source.dart';
import '../../features/home/data/movie_repository_impl.dart';

// Domain Layer
import '../../features/home/domain/repositories/movie_repository.dart';
import '../../features/home/domain/usecases/get_genres_usecase.dart';
import '../../features/home/domain/usecases/get_movies_by_genre_usecase.dart';
import '../../features/home/domain/usecases/get_popular_movies_usecase.dart';

// Presentation Layer - Stores
import '../../features/onboarding/presentation/stores/onboarding_store.dart';

import '../../features/splash/presentation/stores/splash_store.dart';

final getIt = GetIt.instance;

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

  // ─────────────────────────────────────────────────────────────────────────────
  // PRESENTATION LAYER - Stores
  // ─────────────────────────────────────────────────────────────────────────────
  getIt.registerFactory<SplashStore>(
    () => SplashStore(
      getPopularMoviesUseCase: getIt<GetPopularMoviesUseCase>(),
      getGenresUseCase: getIt<GetGenresUseCase>(),
    ),
  );



  // OnboardingStore as singleton - shared across onboarding screens
  getIt.registerLazySingleton<OnboardingStore>(
    () => OnboardingStore(
      getPopularMoviesUseCase: getIt<GetPopularMoviesUseCase>(),
    ),
  );
}

