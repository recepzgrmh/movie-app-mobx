enum PaywallVariant {
  variantA,
  variantB,
  // Add more variants here in the future
}

class PaywallConfig {
  final PaywallVariant variant;

  const PaywallConfig({
    required this.variant,
  });
}
