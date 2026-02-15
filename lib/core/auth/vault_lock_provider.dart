import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vault_lock_provider.g.dart';

@Riverpod(keepAlive: true)
class VaultLockState extends _$VaultLockState {
  Timer? _lockTimer;
  
  @override
  bool build() {
    ref.onDispose(() {
      _cancelTimer();
    });
    // Start as locked
    return false;
  }

  void unlock() {
    state = true;
    _startAutoLockTimer();
  }

  void lock() {
    state = false;
    _cancelTimer();
  }

  void _startAutoLockTimer() {
    _cancelTimer();
    // Auto-lock after 30 seconds of inactivity
    _lockTimer = Timer(const Duration(seconds: 30), () {
      state = false;
    });
  }

  void _cancelTimer() {
    _lockTimer?.cancel();
    _lockTimer = null;
  }

  void resetTimer() {
    if (state) {
      _startAutoLockTimer();
    }
  }
}

// App lifecycle observer provider
@riverpod
class AppLifecycleObserver extends _$AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final vaultLock = ref.read(vaultLockStateProvider.notifier);
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        // Lock vault when app goes to background
        vaultLock.lock();
        break;
      case AppLifecycleState.resumed:
        // Keep locked, require re-authentication
        break;
      case AppLifecycleState.hidden:
        vaultLock.lock();
        break;
    }
  }
}
