part of 'base_di_module.dart';

abstract class DiModule extends BaseDiModule implements Scope {
  void setup(SyncRegistrar it);
}
