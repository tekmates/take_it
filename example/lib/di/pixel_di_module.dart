import 'package:example/features/pixel/pixel_state_manager.dart';
import 'package:take_it/take_it.dart';

class PixelDiModule extends LocalScopeDiModule {
  @override
  Initializer get initializer => Initializer.sync((scope) {
        scope.registerSingleton(
            PixelStateManager(
              redValueStorage: get(),
              greenValueStorage: get(),
              blueValueStorage: get(),
            ),
            dispose: (instance) => instance.dispose());
      });
}
