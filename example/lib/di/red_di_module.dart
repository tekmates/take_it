import 'package:example/features/color/color_state_manager.dart';
import 'package:example/features/color/decrementer.dart';
import 'package:example/features/color/incrementer.dart';
import 'package:example/features/pixel/value_storages.dart';
import 'package:take_it/take_it.dart';

class RedDiModule extends DiModule {
  @override
  void setup(SyncRegistrar it) {
    it
      ..registerFactory<Decrementer>(
          () => DecrementerImpl(get<RedValueStorage>()))
      ..registerFactory<Incrementer>(
          () => IncrementerImpl(get<RedValueStorage>()))
      ..registerSingleton(
          ColorStateManager(
              decrementer: get<Decrementer>(),
              incrementer: get(),
              valueStorage: get<RedValueStorage>()),
          dispose: (instance) => instance.dispose());
  }
}
