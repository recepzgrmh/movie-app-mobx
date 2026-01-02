import 'package:get_it/get_it.dart';
import '../../features/splash/presentation/stores/splash_store.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Stores
  getIt.registerLazySingleton<SplashStore>(() => SplashStore());
}
