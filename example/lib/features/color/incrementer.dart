import 'dart:math';

import 'package:example/core/value_storage.dart';

abstract interface class Incrementer {
  void increment();
}

class IncrementerImpl implements Incrementer {
  IncrementerImpl(this._storage);

  final ValueStorage _storage;

  @override
  void increment() {
    final newValue = _storage.getValue() + 5;
    _storage.saveValue(min(newValue, 255));
  }
}
