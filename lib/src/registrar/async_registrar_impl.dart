import 'package:take_it/src/di_container/di_container.dart';
import 'package:take_it/src/registrar/async_registrar.dart';
import 'package:take_it/src/registrar/sync_registrar.dart';
import 'package:take_it/src/registrar/sync_registrar_impl.dart';

class AsyncRegistrarImpl extends SyncRegistrarImpl implements AsyncRegistrar {
  const AsyncRegistrarImpl(this._getIt) : super(_getIt);

  final DiContainer _getIt;

  @override
  void registerSingletonAsync<T extends Object>(
    CreateAsyncFunc<T> create, {
    String? instanceName,
    DisposeFunc<T>? dispose,
  }) {
    return _getIt.registerSingletonAsync<T>(
      create,
      instanceName: instanceName,
      dispose: dispose,
    );
  }
}
