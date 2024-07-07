import 'package:take_it/src/registrar/sync_registrar.dart';

abstract interface class AsyncRegistrar implements SyncRegistrar {
  void registerSingletonAsync<T extends Object>(
    CreateAsyncFunc<T> create, {
    DisposeFunc<T>? dispose,
  });
}

/// Signature of the create function used by async factories
typedef CreateAsyncFunc<T> = Future<T> Function();
