part of 'base_di_module.dart';

abstract class DiModuleAsync extends BaseDiModule implements IDiModule {
  Future<void> setup(AsyncRegistrar it);
}