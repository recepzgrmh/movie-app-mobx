import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/app/di/di.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/paywall/domain/entities/paywall_config.dart';
import 'package:movie_app/features/paywall/presentation/stores/paywall_store.dart';
import 'package:movie_app/features/paywall/presentation/pages/paywall_variant_a.dart';
import 'package:movie_app/features/paywall/presentation/pages/paywall_variant_b.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  late final PaywallStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<PaywallStore>();
    // Load config on init
    _store.loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Observer(
        builder: (_) {
          if (_store.isLoading && _store.config == null) {
             return const Center(child: CircularProgressIndicator(color: AppColors.redLight));
          }

          // A/B Testing Dispatcher
          switch (_store.activeVariant) {
            case PaywallVariant.variantA:
              return PaywallVariantA(store: _store);
            case PaywallVariant.variantB:
              return PaywallVariantB(store: _store);
          }
        },
      ),
    );
  }
}
