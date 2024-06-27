import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class StateManager<T> {
  T _state;

  StateManager(T initialState) : _state = initialState;

  final StreamController<T> _stateController = StreamController.broadcast();

  Stream<T> get stateStream => _stateController.stream;

  T get state {
    return _state;
  }

  void setState(T state) {
    _state = state;
    _stateController.add(_state);
  }

  void dispose() {
    debugPrint("dispose");
    _stateController.close();
  }
}
