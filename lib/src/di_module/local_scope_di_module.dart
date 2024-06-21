// ignore_for_file: avoid_annotating_with_dynamic
import 'package:take_it/src/di_module/base_di_module.dart';
import 'package:take_it/src/di_module/di_module.dart';
import 'package:take_it/src/get_it_instance.dart';

abstract class LocalScopeDiModule extends _LocalScopeDiModuleImpl
    implements DiModule {
  LocalScopeDiModule() : super(GetIt.asNewInstance());
}

abstract class _LocalScopeDiModuleImpl extends BaseDiModule
    implements DiModule {
  _LocalScopeDiModuleImpl(this._getIt) : super(_getIt);
  final GetIt _getIt;

  @override
  void pushScope(Function() onInit) {
    init(onInit);
  }

  @override
  void popScope() async {
    await reset();
  }

  @override
  Future<void> reset() async {
    await _getIt.reset();
  }

  @override
  bool isRegistered<T extends Object>() =>
      _getIt.isRegistered<T>() ? true : globalGetIt.isRegistered<T>();

  @override
  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    if (_getIt.isRegistered<T>()) {
      return _getIt.get(
        instanceName: instanceName,
        param1: param1,
        param2: param2,
      );
    } else if (globalGetIt.isRegistered<T>()) {
      return globalGetIt.get(
        instanceName: instanceName,
        param1: param1,
        param2: param2,
      );
    }
    throw Exception(
        "Instance of $T not registered inside $runtimeType or  in GlobalScope");
  }

  @override
  T? safeGet<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    return isRegistered<T>()
        ? get<T>(instanceName: instanceName, param1: param1, param2: param2)
        : null;
  }
}
