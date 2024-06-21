import 'dart:async';

import 'package:take_it/src/registrar/base_registrar.dart';

abstract interface class SyncRegistrar implements Registrar {
  void registerFactory<T extends Object>({
    required CreateFunc<T> create,
    String? instanceName,
  });

  T registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    DisposeFunc<T>? dispose,
  });

  void registerLazySingleton<T extends Object>({
    required CreateFunc<T> create,
    String? instanceName,
    DisposeFunc<T>? dispose,
  });
}

/// Signature of the create function used by non async factories
typedef CreateFunc<T> = T Function();

/// Signature for disposing function
typedef DisposeFunc<T> = FutureOr Function(T param);
