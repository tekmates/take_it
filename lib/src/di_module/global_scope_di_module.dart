// ignore_for_file: avoid_annotating_with_dynamic
import 'package:take_it/src/di_module/base_di_module.dart';
import 'package:take_it/src/di_module/di_module.dart';
import 'package:take_it/src/get_it_instance.dart';
import 'package:take_it/take_it.dart';

abstract class GlobalScopeDiModule extends BaseDiModule implements DiModule {
  GlobalScopeDiModule() : super(globalGetIt);

  String get scopeName => toString();

  /// Стэк запущенных скоупов c подсчетом ссылок
  static final Map<String, int> _launchedScopes = {};

  @override
  void pushScope(Function() onInit) {
    final count = _launchedScopes[scopeName];
    if (count == null) {
      /// Cкоуп не запущен, запускаем
      globalGetIt.pushNewScope(scopeName: scopeName);
      _launchedScopes[scopeName] = 1;
      init(onInit);
    } else {
      /// Cкоуп запущен, считаем ссылки
      _launchedScopes[scopeName] = count + 1;
    }
  }

  @override
  void popScope() async {
    final count = _launchedScopes[scopeName];
    if (count == 1) {
      /// Скоуп запущен, 1 ссылка, дропаем
      await globalGetIt.dropScope(scopeName);
      _launchedScopes.remove(scopeName);
    } else if (count == null || count == 0) {
      throw Exception("Cannot call popScope because it is not launched");
    } else {
      /// Скоуп запущен, ссылкок много, считаем
      _launchedScopes[scopeName] = count - 1;
    }
  }

  @override
  Future<void> reset() async {
    await globalGetIt.reset();
  }

  @override
  bool isRegistered<T extends Object>() => globalGetIt.isRegistered<T>();

  @override
  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    return globalGetIt.get(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
    );
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
