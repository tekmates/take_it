import 'dart:async';

import 'package:take_it/src/registrar/async_registrar.dart';
import 'package:take_it/src/registrar/sync_registrar.dart';

class Initializer {
  Initializer._(this._initAsync, this._initSync);

  factory Initializer.sync(InitSync initSync) {
    return Initializer._(null, initSync);
  }

  factory Initializer.async(InitAsync initAsync) {
    return Initializer._(initAsync, null);
  }

  final InitSync? _initSync;
  final InitAsync? _initAsync;

  FutureOr<void> foldAsync({
    required SyncRegistrar Function() syncRegistrar,
    required AsyncRegistrar Function() asyncRegistrar,
  }) async {
    if (_initSync != null) {
      return _initSync?.call(syncRegistrar());
    } else if (_initAsync != null) {
      return _initAsync?.call(asyncRegistrar());
    }
    throw Exception("InitType not initialized");
  }

  dynamic foldSync({
    required SyncRegistrar Function() syncRegistrar,
    required AsyncRegistrar Function() asyncRegistrar,
  }) {
    if (_initSync != null) {
      return _initSync?.call(syncRegistrar());
    } else if (_initAsync != null) {
      return _initAsync?.call(asyncRegistrar());
    }
    throw Exception("InitType not initialized");
  }
}

typedef InitSync = Null Function(SyncRegistrar scope);
typedef InitAsync = Future<void> Function(AsyncRegistrar scope);
