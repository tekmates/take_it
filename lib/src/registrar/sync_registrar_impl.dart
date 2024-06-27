import 'package:get_it/get_it.dart';
import 'package:take_it/src/registrar/sync_registrar.dart';

class SyncRegistrarImpl implements SyncRegistrar {
  const SyncRegistrarImpl(this._getIt);

  final GetIt _getIt;

  @override
  void registerFactory<T extends Object>(
      {required CreateFunc<T> create, String? instanceName}) {
    return _getIt.registerFactory<T>(create, instanceName: instanceName);
  }

  @override
  void registerLazySingleton<T extends Object>(
      {required CreateFunc<T> create,
      String? instanceName,
      DisposeFunc<T>? dispose}) {
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
