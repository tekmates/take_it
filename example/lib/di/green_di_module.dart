import 'package:example/features/color/color_state_manager.dart';
import 'package:example/features/color/decrementer.dart';
import 'package:example/features/color/incrementer.dart';
import 'package:example/features/pixel/value_storages.dart';
import 'package:take_it/take_it.dart';

class GreenDiModule extends DiModule {
  @override
  void setup(SyncRegistrar it) {
    it
      ..registerFactory<Decrementer>(
          create: () => DecrementerImpl(get<GreenValueStorage>()))
      ..registerFactory<Incrementer>(
          create: () => IncrementerImpl(get<GreenValueStorage>()))
      ..registerSingleton(
          ColorStateManager(
              decrementer: get<Decrementer>(),
              incrementer: get(),
              valueStorage: get<GreenValueStorage>()),
          dispose: (instance) => instance.dispose());
  }
}
