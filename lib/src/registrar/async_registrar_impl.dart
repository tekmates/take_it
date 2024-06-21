import 'package:get_it/get_it.dart';
import 'package:take_it/src/registrar/async_registrar.dart';
import 'package:take_it/src/registrar/sync_registrar.dart';
import 'package:take_it/src/registrar/sync_registrar_impl.dart';

class AsyncRegistrarImpl extends SyncRegistrarImpl implements AsyncRegistrar {
  const AsyncRegistrarImpl(this._getIt) : super(_getIt);

  final GetIt _getIt;

  @override
  void registerFactoryAsync<T extends Object>(
      {required CreateAsyncFunc<T> create, String? instanceName}) {
    return _getIt.registerFactoryAsync<T>(create, instanceName: instanceName);
  }

  @override
  void registerLazySingletonAsync<T extends Object>(
      {required CreateAsyncFunc<T> create,
      String? instanceName,
      DisposeFunc<T>? dispose}) {
    return _getIt.registerLazySingletonAsync<T>(
      create,
      instanceName: instanceName,
      dispose: dispose,
    );
  }

  @override
  void registerSingletonAsync<T extends Object>(
      {required CreateAsyncFunc<T> create,
      String? instanceName,
      DisposeFunc<T>? dispose}) {
    return _getIt.registerSingletonAsync<T>(
      create,
      instanceName: instanceName,
      dispose: dispose,
    );
  }
}
