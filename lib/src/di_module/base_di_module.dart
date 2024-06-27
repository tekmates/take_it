// ignore_for_file: avoid_annotating_with_dynamic

import 'package:get_it/get_it.dart';
import 'package:take_it/src/registrar/async_registrar_impl.dart';
import 'package:take_it/src/registrar/sync_registrar_impl.dart';
import 'package:take_it/take_it.dart';

part 'di_module.dart';


part 'di_module_async.dart';

sealed class BaseDiModule implements IDiModule {
  BaseDiModule({
    this.dependencies = const {},
  });

  GetIt _serviceLocator = GetIt.asNewInstance();

  final Set<BaseDiModule> dependencies;

  final Set<BaseDiModule> _parents = {};

  Future<void> init() async {
    for (final dependency in dependencies) {
      dependency._serviceLocator = _serviceLocator;
      await dependency.init();
    }
    final module = this;
    if (module is DiModule) {
      module.setup(SyncRegistrarImpl(_serviceLocator));
    } else if (module is DiModuleAsync) {
      await module.setup(AsyncRegistrarImpl(_serviceLocator));
    } else {
      throw Exception(
          "${module.runtimeType} must extend SyncDiModule or AsyncDiModule.");
    }
    await _serviceLocator.allReady();
  }

  void _init(Function() onInit) {
    final query = <BaseDiModule>{};
    for (final dependency in dependencies) {
      query.add(dependency);
      dependency._serviceLocator = _serviceLocator;
      dependency._init(() => query.remove(dependency));
    }
    final module = this;
    if (module is DiModule) {
      module.setup(SyncRegistrarImpl(_serviceLocator));
      _initContinue(query, onInit);
    } else if (module is DiModuleAsync) {
      module.setup(AsyncRegistrarImpl(_serviceLocator)).then(
            (_) => _serviceLocator.allReady().then(
                  (_) => _initContinue(query, onInit),
                ),
          );
    } else {
      throw Exception(
          "${module.runtimeType} must extend SyncDiModule or AsyncDiModule.");
    }
  }

  void _initContinue(Set<BaseDiModule> query, Function() onInit) {
    if (query.isNotEmpty) {
      _serviceLocator.allReady().then((value) => onInit());
    } else {
      onInit();
    }
  }

  void pushScope(Function() onInit, BaseDiModule? parent) {
    if (parent != null) {
      _parents.add(parent);
      _parents.addAll(parent._parents);
    }
    _init(onInit);
  }

  Future<void> popScope() async {
    await reset();
  }

  @override
  Future<void> reset() async {
    await _serviceLocator.reset();
  }

  List<GetIt> get _scope =>
      [_serviceLocator, ..._parents.map((e) => e._serviceLocator)];

  @override
  bool isRegistered<T extends Object>() {
    for (var serviceLocator in _scope) {
      if (serviceLocator.isRegistered<T>()) return true;
    }
    return false;
  }

  @override
  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    for (var serviceLocator in _scope) {
      if (serviceLocator.isRegistered<T>()) {
        return serviceLocator.get<T>(
          instanceName: instanceName,
          param1: param1,
          param2: param2,
        );
      }
    }
    throw Exception(
      "Error: Instance of type $T is not registered within $runtimeType or "
      "its subtree Scope. Please ensure that $T is correctly registered and "
      "available in the appropriate context.",
    );
  }

  @override
  T? safeGet<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    return isRegistered<T>()
        ? get<T>(
            instanceName: instanceName,
            param1: param1,
            param2: param2,
          )
        : null;
  }
}
