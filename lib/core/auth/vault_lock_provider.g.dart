// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_lock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vaultLockStateHash() => r'57a8e8ba77de9d05fa401566e861e219ed26c50f';

/// See also [VaultLockState].
@ProviderFor(VaultLockState)
final vaultLockStateProvider = NotifierProvider<VaultLockState, bool>.internal(
  VaultLockState.new,
  name: r'vaultLockStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vaultLockStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VaultLockState = Notifier<bool>;
String _$appLifecycleObserverHash() =>
    r'179b6d26887be3b78065758be9311a7ecf34c6cc';

/// See also [AppLifecycleObserver].
@ProviderFor(AppLifecycleObserver)
final appLifecycleObserverProvider =
    AutoDisposeNotifierProvider<AppLifecycleObserver, void>.internal(
  AppLifecycleObserver.new,
  name: r'appLifecycleObserverProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appLifecycleObserverHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppLifecycleObserver = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
