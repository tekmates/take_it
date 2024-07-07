import 'package:example/features/color/color_state_manager.dart';
import 'package:example/features/color/decrementer.dart';
import 'package:example/features/color/incrementer.dart';
import 'package:example/features/pixel/value_storages.dart';
import 'package:take_it/take_it.dart';

class BlueDiModule extends DiModule {
  @override
  void setup(SyncRegistrar it) {
    it
      ..registerFactory<Decrementer>(
          () => DecrementerImpl(get<BlueValueStorage>()))
      ..registerFactory<Incrementer>(
          () => IncrementerImpl(get<BlueValueStorage>()))
      ..registerSingleton(
          ColorStateManager(
              decrementer: get<Decrementer>(),
              incrementer: get(),
              valueStorage: get<BlueValueStorage>()),
          dispose: (instance) => instance.dispose())
      ..registerFactory<String>(() => "1");
  }
}
