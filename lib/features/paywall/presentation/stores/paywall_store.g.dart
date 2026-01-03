// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paywall_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PaywallStore on _PaywallStore, Store {
  late final _$selectedPlanAtom = Atom(
    name: '_PaywallStore.selectedPlan',
    context: context,
  );

  @override
  SubscriptionPlan get selectedPlan {
    _$selectedPlanAtom.reportRead();
    return super.selectedPlan;
  }

  @override
  set selectedPlan(SubscriptionPlan value) {
    _$selectedPlanAtom.reportWrite(value, super.selectedPlan, () {
      super.selectedPlan = value;
    });
  }

  late final _$isFreeTrialEnabledAtom = Atom(
    name: '_PaywallStore.isFreeTrialEnabled',
    context: context,
  );

  @override
  bool get isFreeTrialEnabled {
    _$isFreeTrialEnabledAtom.reportRead();
    return super.isFreeTrialEnabled;
  }

  @override
  set isFreeTrialEnabled(bool value) {
    _$isFreeTrialEnabledAtom.reportWrite(value, super.isFreeTrialEnabled, () {
      super.isFreeTrialEnabled = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_PaywallStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$purchaseAsyncAction = AsyncAction(
    '_PaywallStore.purchase',
    context: context,
  );

  @override
  Future<void> purchase() {
    return _$purchaseAsyncAction.run(() => super.purchase());
  }

  late final _$_PaywallStoreActionController = ActionController(
    name: '_PaywallStore',
    context: context,
  );

  @override
  void selectPlan(SubscriptionPlan plan) {
    final _$actionInfo = _$_PaywallStoreActionController.startAction(
      name: '_PaywallStore.selectPlan',
    );
    try {
      return super.selectPlan(plan);
    } finally {
      _$_PaywallStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleFreeTrial(bool value) {
    final _$actionInfo = _$_PaywallStoreActionController.startAction(
      name: '_PaywallStore.toggleFreeTrial',
    );
    try {
      return super.toggleFreeTrial(value);
    } finally {
      _$_PaywallStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedPlan: ${selectedPlan},
isFreeTrialEnabled: ${isFreeTrialEnabled},
isLoading: ${isLoading}
    ''';
  }
}
