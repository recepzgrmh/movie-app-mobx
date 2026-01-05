
import '../entities/paywall_config.dart';

abstract class PaywallConfigRepository {
  /// Fetches the remote or local configuration for the paywall
  Future<PaywallConfig> getConfig();
}
