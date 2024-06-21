import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:take_it/src/registrar/async_registrar_impl.dart';
import 'package:take_it/src/registrar/sync_registrar_impl.dart';
import 'package:take_it/take_it.dart';

export 'package:get_it/get_it.dart';

abstract class BaseDiModule implements DiModule {
  BaseDiModule(
    this._getIt, {
    this.dependencies = const {},
  });

  GetIt _getIt;

  final Set<BaseDiModule> dependencies;

  Initializer get initializer;

  Future<void> initAsync() async {
    for (final dependency in dependencies) {
      dependency._setParentContainer(_getIt);
      await dependency.initAsync();
    }
    final initialize = initializer;
    await initialize.foldAsync(
      syncRegistrar: () => SyncRegistrarImpl(_getIt),
      asyncRegistrar: () => AsyncRegistrarImpl(_getIt),
    );
    await _getIt.allReady();
  }

  void init(Function() onInit) {
    final query = <BaseDiModule>{};
    for (final dependency in dependencies) {
      query.add(dependency);
      dependency._setParentContainer(_getIt);
      dependency.init(() => query.remove(dependency));
    }
    final initialize = initializer;
    final result = initialize.foldSync(
      syncRegistrar: () => SyncRegistrarImpl(_getIt),
      asyncRegistrar: () => AsyncRegistrarImpl(_getIt),
    );
    if (result is Future) {
      debugPrint("di_log result is Future");
      result.then(
        (_) => _getIt.allReady().then(
              (_) => _initContinue(query, onInit),
            ),
      );
    } else if (result == null) {
      debugPrint("di_log result null");
      _initContinue(query, onInit);
    } else {
      throw Exception("Invalid implementation initModule");
    }
  }

  void _initContinue(Set<BaseDiModule> query, Function() onInit) {
    if (query.isNotEmpty) {
      _getIt.allReady().then((value) => onInit());
    } else {
      onInit();
    }
  }

  void _setParentContainer(GetIt getIt) {
    _getIt = getIt;
  }

  void pushScope(Function() onInit);

  void popScope();
}
