// ignore_for_file: avoid_annotating_with_dynamic
import 'package:take_it/take_it.dart';

sealed class Entity<T> {
  T getObject([dynamic param]);
}

class Factory<T> extends Entity<T> {
  Factory(this._create);

  final CreateFunc<T> _create;

  @override
  T getObject([dynamic param]) {
    return _create();
  }
}

class FactoryParam<T, P> extends Entity<T> {
  FactoryParam(this._create);

  final CreateFuncParam<T, P> _create;

  @override
  T getObject([dynamic param]) {
    return _create(param);
  }
}

class Singleton<T> extends Entity<T> {
  Singleton(T instance)
      : _create = null,
        _instance = instance;

  Singleton.lazy(CreateFunc<T> create)
      : _create = create,
        _instance = null;

  final CreateFunc<T>? _create;
  T? _instance;

  @override
  T getObject([dynamic param]) {
    return _instance ?? _createInstance();
  }

  T _createInstance() {
    _instance = _create!.call();
    return _instance!;
  }
}

class SingletonAsync<T> extends Entity<T> {
  SingletonAsync(this._create);

  final CreateAsyncFunc<T> _create;
  T? _instance;

  @override
  T getObject([dynamic param]) {
    return _instance!;
  }

  Future<void> createAsync() async {
    _instance = await _create();
  }
}
