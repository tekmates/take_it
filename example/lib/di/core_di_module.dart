import 'package:example/features/pixel/value_storages.dart';
import 'package:flutter/cupertino.dart';
import 'package:take_it/take_it.dart';

class CoreDiModule extends GlobalScopeDiModule {
  @override
  Initializer get initializer => Initializer.async((scope) async {
    debugPrint("di_log start init core");
        await Future.delayed(Duration(seconds: 1));
    debugPrint("di_log delayed init core");
        scope
          ..registerSingletonAsync(
            create: () async {
              debugPrint("di_log registerSingletonAsync");
              await Future.delayed(Duration(seconds: 1));
              debugPrint("di_log await registerSingletonAsync");
              return RedValueStorage();
            },
          )
          ..registerSingleton(
            GreenValueStorage(),
          )
          ..registerLazySingleton(
            create: () => BlueValueStorage(),
          );
      });
}
