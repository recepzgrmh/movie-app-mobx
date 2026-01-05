import 'package:mobx/mobx.dart';
import '../../domain/entities/paywall_config.dart';
import '../../domain/usecases/get_paywall_config_usecase.dart';

part 'paywall_store.g.dart';

enum SubscriptionPlan { weekly, monthly, yearly }

class PaywallStore = _PaywallStore with _$PaywallStore;

abstract class _PaywallStore with Store {

  final GetPaywallConfigUseCase getPaywallConfigUseCase;

  _PaywallStore({required this.getPaywallConfigUseCase});

  @observable
  SubscriptionPlan selectedPlan = SubscriptionPlan.yearly;

  @observable
  bool isFreeTrialEnabled = false;

  @observable
  bool isLoading = false;

  @observable
  PaywallConfig? config;

  @computed
  PaywallVariant get activeVariant => config?.variant ?? PaywallVariant.variantA;

  @action
  Future<void> loadConfig() async {
    isLoading = true;
    try {
      config = await getPaywallConfigUseCase();
    } catch (_) {
      // Fallback is handled by activeVariant getter (returns variantA if config is null)
    } finally {
      isLoading = false;
    }
  }

  @action
  void selectPlan(SubscriptionPlan plan) {
    selectedPlan = plan;
  }

  @action
  void toggleFreeTrial(bool value) {
    isFreeTrialEnabled = value;
    // Auto-select yearly plan when free trial is enabled
    if (value) {
      selectedPlan = SubscriptionPlan.yearly;
    }
  }

  @action
  Future<void> purchase() async {
    isLoading = true;
    try {
      // Simulation of a purchase delay
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      isLoading = false;
    }
  }
}
