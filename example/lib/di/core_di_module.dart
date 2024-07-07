import 'package:example/features/pixel/value_storages.dart';
import 'package:flutter/cupertino.dart';
import 'package:take_it/take_it.dart';

class CoreDiModule extends DiModuleAsync {
  @override
  Future<void> setup(AsyncRegistrar it) async {
    debugPrint("di_log start init core");
    await Future.delayed(Duration(seconds: 5));
    debugPrint("di_log delayed init core");
    it
      ..registerSingletonAsync(
        () async {
          debugPrint("di_log registerSingletonAsync");
          await Future.delayed(Duration(seconds: 5));
          debugPrint("di_log await registerSingletonAsync");
          return RedValueStorage();
        },
      )
      ..registerSingleton(
        GreenValueStorage(),
      )
      ..registerLazySingleton(
        () => BlueValueStorage(),
      )
      ..registerFactory<String>(() => "3");
  }
}
