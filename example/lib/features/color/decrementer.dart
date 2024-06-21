import 'dart:math';

import 'package:example/core/value_storage.dart';

abstract interface class Decrementer {
  void decrement();
}

class DecrementerImpl implements Decrementer {
  final ValueStorage _storage;

  DecrementerImpl(this._storage);

  @override
  void decrement() {
    final newValue = _storage.getValue() - 5;
    _storage.saveValue(max(newValue, 0));
  }
}
