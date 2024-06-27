part of 'base_di_module.dart';

abstract class DiModule extends BaseDiModule implements IDiModule {
  void setup(SyncRegistrar it);
}
