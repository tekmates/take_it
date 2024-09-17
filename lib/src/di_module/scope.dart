// ignore_for_file: avoid_annotating_with_dynamic
abstract interface class Scope {
  bool isRegistered<T extends Object>();

  T get<T extends Object>({
    dynamic param,
  });

  T? safeGet<T extends Object>({
    dynamic param,
  });
}
