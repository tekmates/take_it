import 'dart:math';

import 'package:example/core/value_storage.dart';

abstract interface class Decrementer {
  void decrement();
}

class DecrementerImpl implements Decrementer {
  DecrementerImpl(this._storage);

  final ValueStorage _storage;

  @override
  void decrement() {
    final newValue = _storage.getValue() - 5;
    _storage.saveValue(max(newValue, 0));
  }
}
