import 'package:take_it/src/di_container/di_container.dart';
import 'package:take_it/src/registrar/sync_registrar.dart';

class SyncRegistrarImpl implements SyncRegistrar {
  const SyncRegistrarImpl(this._getIt);

  final DiContainer _getIt;

  @override
  void registerFactory<T extends Object>(CreateFunc<T> create) {
    return _getIt.registerFactory<T>(create);
  }

  @override
  void registerLazySingleton<T extends Object>(
    CreateFunc<T> create, {
    String? instanceName,
    DisposeFunc<T>? dispose,
  }) {
    return _getIt.registerLazySingleton<T>(
      create,
      instanceName: instanceName,
      dispose: dispose,
    );
  }

  @override
  T registerSingleton<T extends Object>(T instance,
      {String? instanceName, DisposeFunc<T>? dispose}) {
    return _getIt.registerSingleton<T>(
      instance,
      instanceName: instanceName,
      dispose: dispose,
    );
  }
}
