import '../entities/paywall_config.dart';
import '../repositories/paywall_config_repository.dart';

class GetPaywallConfigUseCase {
  final PaywallConfigRepository repository;

  GetPaywallConfigUseCase(this.repository);

  Future<PaywallConfig> call() async {
    return repository.getConfig();
  }
}
