import 'dart:math';

import '../../domain/entities/paywall_config.dart';
import '../../domain/repositories/paywall_config_repository.dart';

class PaywallConfigRepositoryImpl implements PaywallConfigRepository {
  PaywallConfig? _cachedConfig;

  @override
  Future<PaywallConfig> getConfig() async {
    // Return cached config if available
    if (_cachedConfig != null) {
      return _cachedConfig!;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simple random A/B test logic
    final random = Random();
    final isVariantA = random.nextBool();

    _cachedConfig = PaywallConfig(
      variant: isVariantA ? PaywallVariant.variantA : PaywallVariant.variantB,
    );
    
    return _cachedConfig!;
  }
}
