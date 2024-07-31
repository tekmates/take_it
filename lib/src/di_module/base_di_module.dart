// ignore_for_file: avoid_annotating_with_dynamic

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_it/src/di_container/di_container.dart';
import 'package:take_it/take_it.dart';

part '../di_scope_builder.dart';

part 'di_module.dart';

part 'di_module_async.dart';

sealed class BaseDiModule extends ChangeNotifier implements IDiModule {
  BaseDiModule({
    this.dependencies = const {},
  });

  DiContainer _diContainer = DiContainer();

  final Set<BaseDiModule> dependencies;

  Future<void> _initAsync() async {
    for (final dependency in dependencies) {
      dependency._diContainer = _diContainer;
      await dependency._initAsync();
    }
    final module = this;
    if (module is DiModule) {
      module.setup(_diContainer);
    } else if (module is DiModuleAsync) {
      await module.setup(_diContainer);
    } else {
      throw Exception(
          "${module.runtimeType} must extend SyncDiModule or AsyncDiModule.");
    }
    await _diContainer.allReady();
  }

  void _init(Function() onInit, {bool isNeedNotify = true}) {
    final query = <BaseDiModule>{};
    for (final dependency in dependencies) {
      query.add(dependency);
      dependency._diContainer = _diContainer;
      dependency._init(() => query.remove(dependency), isNeedNotify: false);
    }
    final module = this;
    if (module is DiModule) {
      module.setup(_diContainer);
      _initContinue(query, onInit);
    } else if (module is DiModuleAsync) {
      module.setup(_diContainer).then(
            (_) => _diContainer.allReady().then(
                  (_) => _initContinue(query, onInit),
                ),
          );
    } else {
      throw Exception(
          "${module.runtimeType} must extend SyncDiModule or AsyncDiModule.");
    }
    if (isNeedNotify) _notify();
  }

  void _notify() {
    notifyListeners();
  }

  void _initContinue(Set<BaseDiModule> query, Function() onInit) {
    if (query.isNotEmpty) {
      _diContainer.allReady().then((value) => onInit());
    } else {
      onInit();
    }
  }

  void _pushScope(Function() onInit, BaseDiModule? parent) {
    if (parent != null) {
      _diContainer = DiContainer.fromScope(parent._diContainer);
    }

    _init(onInit, isNeedNotify: false);
  }

  void _updateScope(BaseDiModule? parent) {
    _diContainer.updateScope(parent?._diContainer);
  }

  Future<void> _popScope() async {
    await _reset(isNeedNotify: false);
  }

  Future<void> _reset({bool isNeedNotify = true}) async {
    await _diContainer.reset();
    if (isNeedNotify) _notify();
  }

  @visibleForTesting
  Future<void> resetTest() {
    return _reset();
  }

  @override
  bool isRegistered<T extends Object>() {
    return _diContainer.isRegistered<T>();
  }

  @override
  T get<T extends Object>({
    dynamic param,
  }) {
    if (isRegistered<T>()) {
      return _diContainer.get<T>(param: param);
    }
    throw Exception(
      "Error: Instance of type $T is not registered within $runtimeType or "
      "its subtree Scope. Please ensure that $T is correctly registered and "
      "available in the appropriate context.",
    );
  }

  @override
  T? safeGet<T extends Object>({
    dynamic param,
  }) {
    return isRegistered<T>()
        ? get<T>(
            param: param,
          )
        : null;
  }
}
