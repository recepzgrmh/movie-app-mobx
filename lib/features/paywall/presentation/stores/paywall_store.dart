import 'package:mobx/mobx.dart';

part 'paywall_store.g.dart';

enum SubscriptionPlan { weekly, monthly, yearly }

class PaywallStore = _PaywallStore with _$PaywallStore;

abstract class _PaywallStore with Store {
  @observable
  SubscriptionPlan selectedPlan = SubscriptionPlan.yearly;

  @observable
  bool isFreeTrialEnabled = false;

  @observable
  bool isLoading = false;

  @action
  void selectPlan(SubscriptionPlan plan) {
    selectedPlan = plan;
  }

  @action
  void toggleFreeTrial(bool value) {
    isFreeTrialEnabled = value;
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
