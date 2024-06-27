// ignore_for_file: avoid_annotating_with_dynamic
abstract interface class IDiModule {
  Future<void> reset();

  bool isRegistered<T extends Object>();

  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  });

  T? safeGet<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  });
}
